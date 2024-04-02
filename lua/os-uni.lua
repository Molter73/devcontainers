local name = 'os-uni-builder'

local M = {}

M.setup = function(opts)
    local repo_path = opts.repo_path or os.exit(1)
    return {
        name = name,
        image = 'quay.io/mmoltras/devcontainers:os-uni',
        workingDir = repo_path,
        command = { '/bin/bash', },
        env = {
            { name = 'CMAKE_EXPORT_COMPILE_COMMANDS', value = 'ON', },
        },
        securityContext = {
            privileged = true,
        },
        volumeMounts = opts.volumes or {},
        stdin = true,
        tty = true,
    }
end

return M
