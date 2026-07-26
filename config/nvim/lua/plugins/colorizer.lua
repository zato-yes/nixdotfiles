return {
	"catgoose/nvim-colorizer.lua", -- or NvChad/nvim-colorizer.lua
	event = "BufReadPre",
	opts = {
		filetypes = { "*" }, -- or explicitly list "qml", "css", etc.
		user_default_options = {
			RGB = true, -- #RGB hex codes
			RRGGBB = true, -- #RRGGBB hex codes
			RRGGBBAA = true, -- #RRGGBBAA hex codes
			css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, etc.
			css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			mode = "background", -- or "foreground", "virtualtext"
		},
	},
}
