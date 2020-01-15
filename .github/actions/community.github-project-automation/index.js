const core = require("@actions/core");
const github = require("@actions/github");
const fetch = require("node-fetch");

const project = core.getInput("project");
const column = core.getInput("column");
const backend = core.getInput("backend");

// This is a constant key used by https://github.com/taxfix/github-project-automation-backend
// to know that the request comes from us at Taxfix.
const API_KEY = "d098291f-b62c-47e5-84a7-d76d2a5db310";

const getData = () => {
  const { eventName, payload } = github.context;
  if (eventName !== "pull_request" && eventName !== "issues") {
    throw new Error(
      `Only pull requests or issues allowed, received:\n${eventName}`
    );
  }

  const githubData =
    eventName === "issues" ? payload.issue : payload.pull_request;

  return {
    eventName,
    action: payload.action,
    nodeId: githubData.node_id,
    url: githubData.html_url
  };
};

(async () => {
  const data = {
    ...getData(),
    project,
    column
  };
  await fetch(backend, {
    method: "post",
    body: JSON.stringify(data),
    headers: { "Content-Type": "application/json", Authorization: API_KEY }
  }).then(res => {
    if (res.ok) {
      const { message } = res.json();
      console.log(message);
    } else {
      const { error } = res.json();
      core.setFailed(error);
    }
  });
})();
