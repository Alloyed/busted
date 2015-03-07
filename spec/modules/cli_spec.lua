local path = require 'pl.path'

describe('Tests command-line interface', function()
  it('default options', function()
    local defaultOutput = 'default_output_handler'
    local lpath = './src/?.lua;./src/?/?.lua;./src/?/init.lua'
    local cpath = path.is_windows and './csrc/?.dll;./csrc/?/?.dll;' or './csrc/?.so;./csrc/?/?.so;'
    local cli = require 'busted.modules.cli'({ batch = true, defaultOutput = defaultOutput })
    local args = cli:parse({})
    assert.is_equal(defaultOutput, args.o)
    assert.is_equal(defaultOutput, args.output)
    assert.is_same({'./spec'}, args.ROOT)
    assert.is_equal('./', args.d)
    assert.is_equal('./', args.cwd)
    assert.is_equal('_spec', args.p)
    assert.is_equal('_spec', args.pattern)
    assert.is_equal('os.time()', args.seed)
    assert.is_equal('en', args.lang)
    assert.is_equal(1, args['repeat'])
    assert.is_equal(lpath, args.m)
    assert.is_equal(lpath, args.lpath)
    assert.is_equal(cpath, args.cpath)
    assert.is_nil(args.c)
    assert.is_nil(args.coverage)
    assert.is_nil(args.version)
    assert.is_nil(args.v)
    assert.is_nil(args.verbose)
    assert.is_nil(args.l)
    assert.is_nil(args.list)
    assert.is_nil(args.s)
    assert.is_nil(args['enable-sound'])
    assert.is_nil(args['no-keep-going'])
    assert.is_nil(args['no-recursive'])
    assert.is_nil(args['suppress-pending'])
    assert.is_nil(args['defer-print'])
    assert.is_nil(args.shuffle)
    assert.is_nil(args['shuffle-files'])
    assert.is_nil(args.sort)
    assert.is_nil(args['sort-files'])
    assert.is_nil(args.r)
    assert.is_nil(args.run)
    assert.is_nil(args.filter)
    assert.is_nil(args['filter-out'])
    assert.is_nil(args.helper)
    assert.is_same({}, args.t)
    assert.is_same({}, args.tags)
    assert.is_same({}, args['exclude-tags'])
    assert.is_same({}, args.Xoutput)
    assert.is_same({}, args.Xhelper)
    assert.is_same({'lua', 'moonscript'}, args.loaders)
  end)

  it('standalone options disables ROOT and --pattern', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({})
    assert.is_nil(args.ROOT)
    assert.is_nil(args.p)
    assert.is_nil(args.pattern)
  end)

  it('specify flags', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '-v', '--version', '--coverage', '--defer-print', '--suppress-pending' })
    assert.is_true(args.v)
    assert.is_true(args.verbose)
    assert.is_true(args.version)
    assert.is_true(args.coverage)
    assert.is_true(args['defer-print'])
    assert.is_true(args['suppress-pending'])
  end)

  it('specify more flags', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '-s', '--list', '--no-keep-going', '--no-recursive' })
    assert.is_true(args.s)
    assert.is_true(args['enable-sound'])
    assert.is_true(args.l)
    assert.is_true(args.list)
    assert.is_true(args['no-keep-going'])
    assert.is_true(args['no-recursive'])
  end)

  it('specify shuffle flags', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '--shuffle', '--shuffle-files', '--shuffle-tests' })
    assert.is_true(args.shuffle)
    assert.is_true(args['shuffle-files'])
    assert.is_true(args['shuffle-tests'])
  end)

  it('specify short flags', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '--sort', '--sort-files', '--sort-tests' })
    assert.is_true(args.sort)
    assert.is_true(args['sort-files'])
    assert.is_true(args['sort-tests'])
  end)

  it('specify ROOT arg and --pattern', function()
    local cli = require 'busted.modules.cli'({ batch = true })
    local args = cli:parse({ '-p', 'match_files', 'root_is_here' })
    assert.is_same({'./root_is_here'}, args.ROOT)
    assert.is_equal('match_files', args.p)
    assert.is_equal('match_files', args.pattern)
  end)

  it('specify multiple root paths', function()
    local cli = require 'busted.modules.cli'({ batch = true })
    local args = cli:parse({'root1_path', 'root2_path', 'root3_path'})
    assert.is_same({'./root1_path', './root2_path', './root3_path'}, args.ROOT)
  end)

  it('specify --cwd', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '--cwd=/path/to/dir' })
    assert.is_equal('/path/to/dir', args.d)
    assert.is_equal('/path/to/dir', args.cwd)
  end)

  it('specify --cwd multiple times', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '--cwd=/path/to', '-d', 'dir', '--cwd=subdir' })
    assert.is_equal('/path/to/dir/subdir', args.d)
    assert.is_equal('/path/to/dir/subdir', args.cwd)
  end)

  it('specify --cwd multiple times with multiple roots', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '--cwd=/path/to', '-d', 'dir', '--cwd=/new/path' })
    assert.is_equal('/new/path', args.d)
    assert.is_equal('/new/path', args.cwd)
  end)

  it('specify --run', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '--run=task' })
    assert.is_equal('task', args.r)
    assert.is_equal('task', args.run)
  end)

  it('specify --lang', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '--lang=fr' })
    assert.is_equal('fr', args.lang)
  end)

  it('specify --repeat', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '--repeat=23' })
    assert.is_equal(23, args['repeat'])
  end)

  it('specify output library', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '-o', 'output_handler', '-Xoutput', '--flag,-f', '-Xoutput', '--opt=val' })
    assert.is_equal('output_handler', args.o)
    assert.is_equal('output_handler', args.output)
    assert.is_same({'--flag', '-f', '--opt=val'}, args.Xoutput)
  end)

  it('specify helper script', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '--helper=helper_script', '-Xhelper', '--flag,-f', '-Xhelper', '--opt=val'  })
    assert.is_equal('helper_script', args.helper)
    assert.is_same({'--flag', '-f', '--opt=val'}, args.Xhelper)
  end)

  it('specify --tags and --exclude-tags', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '--tags=tag1,tag2', '-t', 'tag3', '--exclude-tags=etag1', '--exclude-tags=etag2,etag3' })
    assert.is_same({'tag1', 'tag2', 'tag3'}, args.t)
    assert.is_same({'tag1', 'tag2', 'tag3'}, args.tags)
    assert.is_same({'etag1', 'etag2', 'etag3'}, args['exclude-tags'])
  end)

  it('specify --filter and --filter-out', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '--filter=_filt', '--filter-out=_filterout' })
    assert.is_equal('_filt', args.filter)
    assert.is_equal('_filterout', args['filter-out'])
  end)

  it('specify --loaders', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '--loaders=load1,load2', '--loaders=load3' })
    assert.is_same({'load1', 'load2', 'load3'}, args.loaders)
  end)

  it('specify --lpath', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '-d', '/root', '--lpath=./path1/?.lua', '-m', './path2/?.lua' })
    assert.is_equal('/root/path1/?.lua;/root/path2/?.lua', args.m)
    assert.is_equal('/root/path1/?.lua;/root/path2/?.lua', args.lpath)
  end)

  it('specify --cpath', function()
    local cli = require 'busted.modules.cli'()
    local args = cli:parse({ '-d', '/croot', '--lpath=./path1/?.so', '-m', './path2/?.so' })
    assert.is_equal('/croot/path1/?.so;/croot/path2/?.so', args.m)
    assert.is_equal('/croot/path1/?.so;/croot/path2/?.so', args.lpath)
  end)
end)

describe('Tests using .busted tasks', function()
  it('default options', function()
    local defaultOutput = 'default_output_handler'
    local lpath = 'spec/.hidden/src/?.lua;spec/.hidden/src/?/?.lua;spec/.hidden/src/?/init.lua'
    local cpath = path.is_windows and 'spec/.hidden/csrc/?.dll;spec/.hidden/csrc/?/?.dll;' or 'spec/.hidden/csrc/?.so;spec/.hidden/csrc/?/?.so;'
    local cli = require 'busted.modules.cli'({ batch = true, defaultOutput = defaultOutput })
    local args = cli:parse({ '--cwd=spec/.hidden' })
    assert.is_equal(defaultOutput, args.o)
    assert.is_equal(defaultOutput, args.output)
    assert.is_same({'spec/.hidden/spec'}, args.ROOT)
    assert.is_equal('spec/.hidden', args.d)
    assert.is_equal('spec/.hidden', args.cwd)
    assert.is_equal('_spec', args.p)
    assert.is_equal('_spec%.lua$', args.pattern)
    assert.is_equal('os.time()', args.seed)
    assert.is_equal('en', args.lang)
    assert.is_equal(1, args['repeat'])
    assert.is_equal(lpath, args.m)
    assert.is_equal(lpath, args.lpath)
    assert.is_equal(cpath, args.cpath)
    assert.is_nil(args.c)
    assert.is_nil(args.coverage)
    assert.is_nil(args.version)
    assert.is_nil(args.v)
    assert.is_nil(args.verbose)
    assert.is_nil(args.l)
    assert.is_nil(args.list)
    assert.is_nil(args.s)
    assert.is_nil(args['enable-sound'])
    assert.is_nil(args['no-keep-going'])
    assert.is_nil(args['no-recursive'])
    assert.is_nil(args['suppress-pending'])
    assert.is_nil(args['defer-print'])
    assert.is_nil(args.shuffle)
    assert.is_nil(args['shuffle-files'])
    assert.is_nil(args.sort)
    assert.is_nil(args['sort-files'])
    assert.is_nil(args.r)
    assert.is_nil(args.run)
    assert.is_nil(args.filter)
    assert.is_nil(args['filter-out'])
    assert.is_nil(args.helper)
    assert.is_same({'tag11', 'tag22', 'tag33'}, args.t)
    assert.is_same({'tag11', 'tag22', 'tag33'}, args.tags)
    assert.is_same({'etag11', 'etag22', 'etag33'}, args['exclude-tags'])
    assert.is_same({'-f', '--flag'}, args.Xoutput)
    assert.is_same({'-v', '--verbose'}, args.Xhelper)
    assert.is_same({'terra', 'moonscript'}, args.loaders)
  end)

  it('load configuration options', function()
    local cli = require 'busted.modules.cli'({ batch = true, defaultOutput = defaultOutput })
    local args = cli:parse({ '--cwd=spec/.hidden', '--run=test' })
    assert.is_equal('_test%.lua$', args.pattern)
    assert.is_same({'test1', 'test2', 'test3'}, args.tags)
    assert.is_same({'etest1', 'etest2', 'etest3'}, args['exclude-tags'])
    assert.is_same({'-s','--sound'}, args.Xoutput)
    assert.is_same({'-t', '--print'}, args.Xhelper)
    assert.is_same({'lua', 'terra'}, args.loaders)
  end)

  it('load configuration options and override with command-line', function()
    local cli = require 'busted.modules.cli'({ batch = true, defaultOutput = defaultOutput })
    local args = cli:parse({ '--cwd=spec/.hidden', '--run=test', '-t', 'tag1', '-p', 'patt', '--loaders=moonscript' })
    assert.is_equal('patt', args.pattern)
    assert.is_same({'tag1'}, args.tags)
    assert.is_same({'etest1', 'etest2', 'etest3'}, args['exclude-tags'])
    assert.is_same({'-s','--sound'}, args.Xoutput)
    assert.is_same({'-t', '--print'}, args.Xhelper)
    assert.is_same({'moonscript'}, args.loaders)
  end)
end)

describe('Tests command-line parse errors', function()
  before_each(function()
    package.loaded['cliargs'] = nil
  end)

  it('with invalid --repeat value', function()
    local cli = require 'busted.modules.cli'()
    cli:set_name('myapp')
    local args, err = cli:parse({ '--repeat=abc'})
    assert.is_nil(args)
    assert.is_equal('myapp: error: argument to --repeat must be a number; re-run with --help for usage.', err)
  end)

  it('with same tag for --tags and --exclude-tags', function()
    local cli = require 'busted.modules.cli'()
    cli:set_name('myapp')
    local args, err = cli:parse({ '--tags=tag1', '--exclude-tags=tag1' })
    assert.is_nil(args)
    assert.is_equal('myapp: error: Cannot use --tags and --exclude-tags for the same tags', err)
  end)
end)
