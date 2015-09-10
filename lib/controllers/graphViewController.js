const $ = require('atom-space-pen-views').$;
const React = require('react-atom-fork');
const GraphListView = require('../views/graph-list-view');
const RemoteRevision = require('../util/RemoteRevision');
const errorController = require('./errorController');


/**
 * Display or hide a GraphListView for the active editor.
 *
 * If the active editor does not have an existing GraphListView, one will be
 * mounted.
 *
 * @param {Grapher} projectGraphr - a Grapher for the current project
 */
function toggleGraph(projectGraphr) {
  var editor = atom.workspace.getActiveTextEditor();
  if (!editor) return;

  // An unsaved file has no filePath
  var filePath = editor.getPath();
  if (!filePath) return;

  var editorView = atom.views.getView(editor);
  if (!editorView.graphView) {
    var remoteUrl = projectGraphr.repo.getOriginURL(filePath);
    var remoteRevision;
    try {
      remoteRevision = RemoteRevision.create(remoteUrl);
    } catch (e) {
      // the only exception possible occurs when the template string is invalid
      // TODO refactor this to not throw an exception
    }

    // insert the GraphListView after the gutter div
    var mountPoint = $('<div>', {'class': 'git-graph-mount'});
    $(editorView.rootElement).find('.gutter').after(mountPoint);

    editorView.graphView = React.renderComponent(new GraphListView({
      projectGraphr: projectGraphr,
      remoteRevision: remoteRevision,
      editorView: editorView
    }), mountPoint[0]);
  } else {
    editorView.graphView.toggle();
  }
}


// EXPORTS
module.exports = {
  toggleGraph: toggleGraph
};
