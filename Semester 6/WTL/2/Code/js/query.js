function getQueryValues(definitionList) {
  let definitionData = {};
  var query = window.location.search.substring(1);
  var vars = query.split("&");
  vars.forEach(query => {
    var pair = query.split("=");
    definitionData[pair[0]] = decodeURIComponent(pair[1]);
  });
  return definitionData;
}

let definitionList = [
  "customerName",
  "customerEmail",
  "customerPhone",
  "customerReview",
  "spamProtection"
]

let definitionData = getQueryValues(definitionList);
const query_list = document.getElementById('query_list');
definitionList.forEach(key => {
  let dt = document.createElement('dt');
  let dd = document.createElement('dd');
  dt.textContent = key;
  dd.textContent = (definitionData.hasOwnProperty(key) && definitionData[key] != '') ? `${definitionData[key]}` : 'Query unavailable';
  query_list.appendChild(dt);
  query_list.appendChild(dd);
});