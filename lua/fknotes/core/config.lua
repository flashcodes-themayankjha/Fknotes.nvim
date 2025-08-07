local fknotes_config = require("fknotes.config")

-- This module now simply acts as a proxy to the main config.
-- It ensures that any part of the core can access configuration values
-- without creating circular dependencies.

return fknotes_config.get()