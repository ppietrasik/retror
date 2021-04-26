import { csrfToken } from "./csrf";

export const postRequest = async (url, data) => {
  return request(url, "POST", JSON.stringify(data));
}

export const patchRequest = async (url, data) => {
  return request(url, "PATCH", JSON.stringify(data));
}

export const deleteRequest = async url => {
  return await request(url, "DELETE", "");
}

class RequestError extends Error {
  constructor(response) {
    super("The http request failed.");
    this.name = "RequestError";
    this.response = response;
  }
}

const isResponseJson = response => {
  const contentType = response.headers.get('content-type');

  return contentType?.includes('application/json');
 };

const request = async (url, method, body) => {
  const response = await fetch(url, {
    method,
    credentials: "same-origin",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken,
      "X-Requested-With": "XMLHttpRequest",
    },
    body
  });

  if (!response.ok) throw new RequestError(response);
  if (!isResponseJson(response)) return new Object();

  return await response.json();
}