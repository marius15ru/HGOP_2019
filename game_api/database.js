module.exports = function(context) {
  const Client = context('pgClient');
  const configConstructor = context('config');
  const config = configConstructor(context);

  function getClient() {
    return new Client({
      host: config.pgHost,
      user: config.pgUser,
      password: config.pgPassword,
      database: config.pgDatabase,
    });
  }

  setTimeout(() => {
    const client = getClient();
    client.connect((err) => {
      if (err) {
        console.log('failed to connect to postgres!');
      } else {
        console.log('successfully connected to postgres!');
      }
    });
  }, 5000);

  return {
    insertResult: (won, score, total, onSuccess, onError) => {
      const client = getClient();
      client.connect((err) => {
        if (err) {
          onError(err);
          client.end();
        } else {
          const query = {
            text: 'INSERT INTO "GameResult" ("Won", "Score", "Total", "InsertDate") ' +
                      'VALUES($1, $2, $3, CURRENT_TIMESTAMP);',
            values: [won, score, total],
          };
          client.query(query, (err) => {
            if (err) {
              onError(err);
            } else {
              onSuccess(0);
            }
            client.end();
          });
        }
      });
      return;
    },
    // Should call onSuccess with integer.
    getTotalNumberOfGames: (onSuccess, onError) => {
      const client = getClient();
      client.connect((err) => {
        if (err) {
          onError(err);
          client.end();
        } else {
          const query = {
            text: 'SELECT count(*) FROM "GameResult";',
          };
          client.query(query, (err, result) => {
            if (err) {
              onError(err);
            } else {
              onSuccess(result.rows[0].count);
            }
            client.end();
          });
        }
      });
      return;
    },
    // Should call onSuccess with integer.
    getTotalNumberOfWins: (onSuccess, onError) => {
      const client = getClient();
      client.connect((err) => {
        if (err) {
          onError(err);
          client.end(0);
        } else {
          const query = {
            text: 'SELECT count(*) FROM "GameResult" WHERE "Won" = True;',
          };
          client.query(query, (err, result) => {
            if (err) {
              onError(err);
            } else {
              onSuccess(result.rows[0].count);
            }
            client.end();
          });
        }
      });
      return;
    },
    // Should call onSuccess with integer.
    getTotalNumberOf21: (onSuccess, onError) => {
      const client = getClient();
      client.connect((err) => {
        if (err) {
          onError(err);
          client.end();
        } else {
          const query = {
            text: 'SELECT count(*) FROM "GameResult" WHERE "Total" = 21;',
          };
          client.query(query, (err, result) => {
            if (err) {
              onError(err);
            } else {
              onSuccess(result.rows[0].count);
            }
            client.end();
          });
        }
      });
      return;
    },
  };
};
