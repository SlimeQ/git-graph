const Grapher = require('./util/grapher');
const GraphViewController = require('./controllers/graphViewController');
const errorController = require('./controllers/errorController');
const Directory = require('pathwatcher').Directory
const path = require('path');

// reference to the Grapher instance created in initializeContext if this
// project is backed by a git repository.
var projectGraphers = {}

function activate() {
  // git-graph:graph
  atom.commands.add('atom-workspace', 'git-graph:toggle', toggleGraph);
}


function toggleGraph() {
  var editor = atom.workspace.getActivePaneItem()
  if (!editor) return;

  // An unsaved file has no filePath
  filePath = editor.getPath()
  if (!filePath) return;

  // blaming an empty file is useless
  if (editor.isEmpty()) return;

  return atom.project.repositoryForDirectory(new Directory(path.dirname(filePath))).then(
    function(projectRepo) {
      // Ensure this project is backed by a git repository
      if (!projectRepo) {
        errorController.showError('error-not-backed-by-git');
        return;
      }

      if (!(projectRepo.path in projectGraphers)) {
        projectGraphers[projectRepo.path] = new Grapher(projectRepo);
      }

      GraphViewController.toggleGraph(projectGraphers[projectRepo.path]);
    });

}


// EXPORTS
module.exports = {
  config: {
    "useCustomUrlTemplateIfStandardRemotesFail": {
      type: 'boolean',
      default: false
    },
    "customCommitUrlTemplateString": {
      type: 'string',
      default: 'Example -> https://github.com/<%- project %>/<%- repo %>/commit/<%- revision %>'
    },
    "dateFormatString": {
      type: 'string',
      default: 'YYYY-MM-DD'
    },
    "ignoreWhiteSpaceDiffs": {
      type: 'boolean',
      default: false
    }
  },

  toggleGraph: toggleGraph,
  activate: activate
};
