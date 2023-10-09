local name = 'collector-builder'

local M = {}

M.setup = function(opts)
    local repo_path = opts.repo_path or os.exit(1)
    return {
        name = name,
        image = 'quay.io/mmoltras/devcontainers:collector',
        workingDir = repo_path,
        command = { '/bin/bash' },
        env = {
            { name = 'CMAKE_EXPORT_COMPILE_COMMANDS', value = 'ON' },
            { name = 'DISABLE_PROFILING',             value = 'true' },
            { name = 'COLLECTOR_HOST_ROOT',           value = '/host' },
        },
        volumeMounts = opts.volumes or {},
        securityContext = {
            privileged = true,
        },
        stdin = true,
        tty = true,
    }
end

return M
