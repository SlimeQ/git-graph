const moment = require('moment');

/**
 * Parses the graph --porcelain output for a particular line of code into a
 * usable object with properties:
 *
 * commit: the commit revision
 * line: the line number (1 indexed)
 * committer: name of the committer of that line
 * date: the date of the commit
 * summary: the summary of the commit
 *
 * @param {string} graphData - the graph --porcelain output for a line of code
 * @param {number} index - the index that the data appeared in an array of line
 *    line data (0 indexed)
 * @return {object} - an object with properties described above
 */
var lineMatcher = /([|\/ *]*) *([a-z0-9]*) *(.*)/;
function parseGraphLine(graphData, index) {
  var parsed = graphData.match(lineMatcher);
  var graphObj = { graph : parsed[1],
                   hash  : parsed[2],
                   summary : parsed[3],
                   line    : index + 1
                 };
  if (graphObj.hash == "" && graphObj.summary == "") {
    graphObj.noCommit = true;
  }
  return graphObj;
}

/**
 * Parses git-graph output into usable array of info objects.
 *
 * @param {string} graphOutput - output from 'git graph --porcelain <file>'
 */
function parseGraphOutput(graphOut) {
  // separate on newlines
  // var singleLineDataSplitRegex = /\n/g;
  console.log(graphOut);
  console.log(graphOut.split('\n'));
  // Split the graph output into data for each line and parse out desired
  // data from each into an object.
  return graphOut.split('\n').map(parseGraphLine);
}

// EXPORTS
module.exports = {
  parseGraph: parseGraphOutput
};
