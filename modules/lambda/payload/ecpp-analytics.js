// JavaScript File
const AWS = require("aws-sdk");
const athena = new AWS.Athena({
  region: "ap-southeast-2"
});

const checkQueryCreateStatus = async queryExecutionId => {
  const params = {
    QueryExecutionId: queryExecutionId /* required */
  };
  let myPromise = new Promise((resolve, reject) => {
    athena.getQueryExecution(params, function (err, data) {
      if (err) console.log(err, err.stack);
      // an error occurred
      else {
        if (
          data &&
          data.QueryExecution &&
          data.QueryExecution.Status &&
          data.QueryExecution.Status.State &&
          data.QueryExecution.Status.State === "RUNNING"
        ) {
          setTimeout(function() {return resolve(checkQueryCreateStatus(queryExecutionId))}, 100);
        } else if (
          data &&
          data.QueryExecution &&
          data.QueryExecution.Status &&
          data.QueryExecution.Status.State &&
          data.QueryExecution.Status.State === "QUEUED"
        ) {
          setTimeout(function() {return resolve(checkQueryCreateStatus(queryExecutionId))}, 100);
        } else {
          console.log("Atehna Query status is Active");
          err ? reject(err.stack) : resolve(data);
        }
      }
    });
  });
  return myPromise;
};
const getQueryResultByExecutionId = async queryExecutionId => {
  const params = {
    QueryExecutionId: queryExecutionId
  };

  let myPromise = new Promise((resolve, reject) => {
    athena.getQueryResults(params, function (err, data) {
      err ? reject(err.stack) : resolve(data);
    });
  });
  return myPromise;
};

const createQueryExecutionId = async (event_path, db_name, s3_loc, table_name) => {

  /** Need to check the event to change the SQL query based on that */
    let qString = '';
  if (event_path === '/dataset/users') {
    qString = `SELECT DISTINCT CASE main.patientsex WHEN 'genderMaleOption' THEN 'Male' WHEN 'genderFemaleOption' THEN 'Female' ELSE patientsex END AS "gender", main.calculatedEDACS as calculated_edacs, main.probabilityofmace as probability_of_mace, main.totalredflags, main.patientage, CASE WHEN main.patientage <= 25 THEN '0-25' WHEN main.patientage > 25 AND main.patientage <= 40 THEN '26-40' WHEN main.patientage > 40 AND main.patientage <= 55 THEN '41-55' WHEN main.patientage > 55 AND main.patientage <= 65 THEN '56-65' WHEN main.patientage > 65 AND main.patientage <= 75 THEN '66-75' WHEN main.patientage >75 THEN '75+' END AS "age_group", md5(to_utf8(main.nhi)) AS hashed_nhi, CAST(CAST(From_iso8601_timestamp(main.firstdatetime) AS TIMESTAMP) AS DATE) AS "date_period" FROM "${db_name}"."${table_name}" AS main INNER JOIN (SELECT DISTINCT nhi, max(firstdatetime) AS latest_event FROM "${db_name}"."${table_name}" GROUP BY nhi) AS latest_event ON latest_event.nhi = main.nhi AND latest_event.latest_event = main.firstdatetime;`

  }
  else {
    qString = `SELECT total.date_period, total.count_of_nhi_in_date_period, total.count_of_distinct_nhi_in_date_period, red_flags.max_red_flags, red_flags.min_red_flags, red_flags.average_red_flags, red_flags.total_instances_with_red_flags, edacs.max_edacs, edacs.min_edacs, edacs.average_edacs, edacs.total_instances_with_edacs, mace.max_mace, mace.min_mace, mace.average_mace, mace.total_instances_with_mace FROM (SELECT count(*) AS "total_rows", count(nhi) AS "count_of_nhi_in_date_period", count(DISTINCT nhi) AS "count_of_distinct_nhi_in_date_period", CAST(CAST(From_iso8601_timestamp(firstdatetime) AS TIMESTAMP) AS DATE) AS "date_period" FROM "${db_name}"."${table_name}" GROUP BY CAST(CAST(From_iso8601_timestamp(firstdatetime) AS TIMESTAMP) AS DATE)) AS total JOIN (SELECT CAST(CAST(From_iso8601_timestamp(firstdatetime) AS TIMESTAMP) AS DATE) AS "date_period", max(totalredflags) AS "max_red_flags", min(totalredflags) AS "min_red_flags", avg(totalredflags) AS "average_red_flags", count(totalredflags) AS "total_instances_with_red_flags" FROM "${db_name}"."${table_name}" GROUP BY CAST(CAST(From_iso8601_timestamp(firstdatetime) AS TIMESTAMP) AS DATE)) AS red_flags ON total.date_period = red_flags.date_period JOIN (SELECT CAST(CAST(From_iso8601_timestamp(firstdatetime) AS TIMESTAMP) AS DATE) AS "date_period", max(calculatedEDACS) AS "max_edacs", min(calculatedEDACS) AS "min_edacs", avg(calculatedEDACS) AS "average_edacs", count(calculatedEDACS) AS "total_instances_with_edacs" FROM "${db_name}"."${table_name}" GROUP BY CAST(CAST(From_iso8601_timestamp(firstdatetime) AS TIMESTAMP) AS DATE)) AS edacs ON edacs.date_period = total.date_period JOIN (SELECT CAST(CAST(From_iso8601_timestamp(firstdatetime) AS TIMESTAMP) AS DATE) AS "date_period", max(probabilityofmace) AS "max_mace", min(probabilityofmace) AS "min_mace", avg(probabilityofmace) AS "average_mace", count(probabilityofmace) AS "total_instances_with_mace" FROM "${db_name}"."${table_name}" GROUP BY CAST(CAST(From_iso8601_timestamp(firstdatetime) AS TIMESTAMP) AS DATE)) AS mace ON mace.date_period = total.date_period;`
    
  }

  const params = {
    QueryString:qString, 
    ResultConfiguration: {
      /* required */
      OutputLocation: s3_loc /* required */ ,
      EncryptionConfiguration: {
        EncryptionOption: "SSE_S3" /* required */
      }
    }
  };
  let myPromise = new Promise((resolve, reject) => {
    athena.startQueryExecution(params, function (err, data) {
      console.log(data)
      data ? resolve(data) : reject(err);
    });
  });
  return myPromise;
};

const waitForReady = async (queryId) => {

  const qs = await checkQueryCreateStatus(queryId.QueryExecutionId); 

   
   return qs
}

const athenaQuery = async (event, db_name, s3_loc, table_name) => {
  let myPromise = new Promise(async (resolve, reject) => {
    try {
      const queryId = await createQueryExecutionId(event.path, db_name, s3_loc, table_name);

    /*  let queryState = "RUNNING";
      while (queryState === "RUNNING" || queryState.QueryExecution.Status.State === "QUEUED") {
        
        queryState = await checkQueryCreateStatus(queryId.QueryExecutionId);

      }*/
      
     const ready = await waitForReady(queryId);
     console.log(ready);
    const queryResult = await getQueryResultByExecutionId(queryId.QueryExecutionId);

      const resp = {};
      resp["Data"] = neatenResponse(queryResult.ResultSet.Rows);
      resolve(resp);

    } catch (err) {
      console.log(err)
      resolve(`Issue with query to table`);
    }
  });
  console.log(myPromise);
  return myPromise;
};

const neatenResponse = response => {
  const headers = response[0].Data;
  const body = response.slice(1, response.length);
  const body_new = body.map(b => {
    let myobj = {};
    b.Data.map((c, index) => {
      myobj[headers[index].VarCharValue] = c.VarCharValue;
    });
    return myobj;
  });
  return body_new;
};

exports.handler = async event => {
  const db_name = process.env.db_name;
  const table_name = process.env.table_name.split("-").join("_");
  const s3_loc = process.env.s3_location;
  const tasks = ["poo"]
  const resps = tasks.map(spec => {
    try {
      return athenaQuery(event, db_name, s3_loc, table_name)
    } catch (err) {
      return err.message;
    }
  });
  const results = await Promise.all(resps);
  console.log(results);
  const response = {
    statusCode: 200,
    headers: {"Access-Control-Allow-Origin": "*"},
    body: JSON.stringify(results[0])
  };
  return response;
};