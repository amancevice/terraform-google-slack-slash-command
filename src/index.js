const config = require('./config.json');
const response = require('./response.json');
const { WebClient } = require('@slack/client');
const slack = new WebClient(config.slack.web_api_token)

/**
 * Log request info.
 *
 * @param {object} req Cloud Function request context.
 */
function logRequest(req) {
  console.log(`HEADERS ${JSON.stringify(req.headers)}`);
  console.log(`REQUEST ${JSON.stringify({
    channel_id: req.body.channel_id,
    user_id: req.body.user_id,
    text: req.body.text
  })}`);
  return req;
}

/**
 * Verify request contains proper validation token.
 *
 * @param {object} req Cloud Function request context.
 */
function verifyToken(req) {
  if (!req.body || req.body.token !== config.slack.verification_token) {
    const error = new Error('Invalid Credentials');
    error.code = 401;
    throw error;
  }
  return req;
}

/**
 * Send message back to issuer.
 *
 * @param {object} res Cloud Function response context.
 */
function sendResponse(req, res) {
  console.log(`RESPONSE ${JSON.stringify(response)}`);
  if (config.slack.response_type === 'dialog') {
    res.send();
    slack.dialog.open({
        trigger_id: req.body.trigger_id,
        dialog: response
      })
      .catch(console.log);
  }
  else {
    res.json(response);
  }
}

/**
 * Send Error message back to issuer.
 *
 * @param {object} err The error object.
 * @param {object} res Cloud Function response context.
 */
function sendError(err, res) {
  console.error(err);
  res.status(err.code || 500).send(err);
  return Promise.reject(err);
}

/**
 * Responds to any HTTP request that can provide a "message" field in the body.
 *
 * @param {object} req Cloud Function request context.
 * @param {object} res Cloud Function response context.
 */
exports.slashCommand = (req, res) => {
  Promise.resolve(req)
    .then(logRequest)
    .then(verifyToken)
    .then((req) => sendResponse(req, res))
    .catch((err) => sendError(err, res));
}
