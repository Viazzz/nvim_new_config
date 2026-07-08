return {
    'danymat/neogen',
    config = true,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
    dependencies = 'L3MON4D3/LuaSnip',
    enabled = true,
    languages = {
        python = {
            template = {
                annotation_convention = 'google', -- можно заменить на "numpydoc"
            },
        },
    },
}
