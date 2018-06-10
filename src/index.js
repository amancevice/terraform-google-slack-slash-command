const auth = require('./auth.json');
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
 * Verify slash command was executed from authorized channel.
 *
 * @param {string} channel Slack channel ID
 */
function verifyChannel(channel) {
  return auth.channels.exclude.indexOf(channel) < 0 &&
        (auth.channels.include.length == 0 ||
         auth.channels.include.indexOf(channel) >= 0)
}

/**
 * Verify user is authorized to execute slash command.
 *
 * @param {string} channel Slack channel ID
 */
function verifyUser(user) {
  return auth.users.exclude.indexOf(user) < 0 &&
        (auth.users.include.length == 0 ||
         auth.users.include.indexOf(user) >= 0)
}

/**
 * Send message back to issuer.
 *
 * @param {object} res Cloud Function response context.
 */
function sendResponse(req, res) {
  if (!verifyChannel(req.body.channel_id)) {
    console.log(`CHANNEL PERMISSION DENIED`);
    res.json(auth.channels.permission_denied);
  }
  else if (!verifyUser(req.body.user_id)) {
    console.log(`USER PERMISSION DENIED`);
    res.json(auth.users.permission_denied);
  }
  else if (config.slack.response_type === 'dialog') {
    console.log(`DIALOG ${JSON.stringify(response)}`);
    res.send();
    slack.dialog.open({
        trigger_id: req.body.trigger_id,
        dialog: response
      })
      .catch(console.error);
  }
  else {
    console.log(`RESPONSE ${JSON.stringify(response)}`);
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
