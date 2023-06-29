ART =  {
        [[    __.-._    ]],
	[[    '-._"7'   ]],
	[[     /'.-c    ]],
	[[     |  /T    ]],
	[[kcm _)_/LI    ]],
	[[              ]]
}

local db = require('dashboard')
local telescope = require('telescope.builtin')

function search_files()
	telescope.find_files {
		cwd = "~/",
		prompt_title = 'Home'
	}
end

function dotfiles()
	telescope.find_files {
		cwd = "~/dotFiles",
		prompt_title = "dotFiles"
	}
end

db.setup {
	config = {
		header = ART,
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


