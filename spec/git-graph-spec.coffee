path                      = require 'path'
temp                      = require 'temp'
fs                        = require 'fs-plus'
GitGraph                  = require '../lib/git-graph'
GraphViewController       = require '../lib/controllers/graphViewController'


configProject = (projectPath) ->
    tempPath = temp.mkdirSync(path.basename(projectPath))
    fs.copySync(projectPath, tempPath)

    if fs.existsSync(path.join(tempPath, 'git.git'))
      fs.renameSync(path.join(tempPath, 'git.git'), path.join(tempPath, '.git'))

    return tempPath

describe "git-graph", ->
  beforeEach ->
    atom.packages.activatePackage('git-graph')
    spyOn(GraphViewController, 'toggleGraph')

  describe "when a single git root folder is loaded", ->
    it 'should toggle graph with the associated git repo', ->

      projectPath = path.join(__dirname, 'fixtures', 'repo1')
      tempPath = configProject(projectPath)

      atom.project.setPaths([tempPath])
      waitsForPromise ->
            atom.project.open(path.join(tempPath, 'a.txt')).then (o) ->
              pane = atom.workspace.getActivePane()
              pane.activateItem(o)


      runs ->
        workspaceElement = atom.views.getView(atom.workspace)

        waitsForPromise ->
          GitGraph.toggleGraph()

        runs ->
          expect(GraphViewController.toggleGraph).toHaveBeenCalled()
          graphr = GraphViewController.toggleGraph.calls[0].args[0]
          expectedGitPath = fs.realpathSync(path.join(tempPath, '.git'))
          expect(graphr.repo.path).toEqual(expectedGitPath)

  describe "when multiple git root folders are loaded", ->
    it 'should toggle graph with the associated git repo', ->
      projectPath1 = path.join(__dirname, 'fixtures', 'repo1')
      tempPath1 = configProject(projectPath1)

      projectPath2 = path.join(__dirname, 'fixtures', 'repo2')
      tempPath2 = configProject(projectPath2)

      atom.project.setPaths([tempPath2, tempPath1])
      waitsForPromise ->
            atom.project.open(path.join(tempPath1, 'a.txt')).then (o) ->
              pane = atom.workspace.getActivePane()
              pane.activateItem(o)

      runs ->
        workspaceElement = atom.views.getView(atom.workspace)
        waitsForPromise ->
          GitGraph.toggleGraph()

        runs ->
          expect(GraphViewController.toggleGraph).toHaveBeenCalled()
          graphr = GraphViewController.toggleGraph.calls[0].args[0]
          expectedGitPath = fs.realpathSync(path.join(tempPath1, '.git'))
          expect(graphr.repo.path).toEqual(expectedGitPath)

  describe "when zero git root folders are active", ->
    it 'should not toggle graph', ->

      projectPath = path.join(__dirname, 'fixtures', 'non-git')
      tempPath = configProject(projectPath)

      atom.project.setPaths([tempPath])
      waitsForPromise ->
            atom.project.open(path.join(tempPath, 'test.txt')).then (o) ->
              pane = atom.workspace.getActivePane()
              pane.activateItem(o)

      runs ->
        workspaceElement = atom.views.getView(atom.workspace)
        waitsForPromise ->
          GitGraph.toggleGraph()

        runs ->
          expect(GraphViewController.toggleGraph).not.toHaveBeenCalled()
