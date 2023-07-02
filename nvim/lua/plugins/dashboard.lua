local yoda_small =  {
        [[    __.-._            Try not.     ]],
	[[    '-._"7'        Do or do not.   ]],
	[[     /'.-c        There is no try. ]],
	[[     |  /T                         ]],
	[[kcm _)_/LI                  -Yoda  ]],
	[[              ]]
}

local yoda_quote = {
	[[          .--.                  Try not.     ]],
	[[::\`--._,'.::.`._.--'/::     Do or do not.   ]],
	[[::::.  `  --:: '  .::::    There is no try. ]],
	[[::::::-:.`'..`'.:-::::::                     ]],
	[[::::::::\ `--' /::::::::              -Yoda  ]]

}

local db = require('dashboard')
local telescope = require('telescope.builtin')

local function search_files()
	telescope.find_files {
		cwd = "~/",
		prompt_title = 'Home'
	}
end

local function dotfiles()
	telescope.find_files {
		cwd = "~/dotFiles",
		prompt_title = "dotFiles"
	}
end

db.setup {
	config = {
		header = yoda_small,
		shortcut = {

        {
          icon = ' ',
          desc = 'Files',
          group = 'Function',
          action = search_files ,
          key = 'f',
        },
        {
          icon = ' ',
          desc = 'Apps',
          group = 'String',
          action = 'Telescope',
          key = 'a',
        },
        {
          icon = ' ',
          desc = 'dotfiles',
          group = 'Constant',
          action = dotfiles,
          key = 'd',
        },
      },
	}
}


