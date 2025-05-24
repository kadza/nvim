require("kadza.core.options")
require("kadza.core.keymaps")
local xml_format = require("kadza.myplugins.format-xml")

vim.api.nvim_create_user_command("FormatXml", function()
  xml_format.format_buffer()
end, {})
