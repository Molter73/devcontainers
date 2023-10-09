local name = 'libs-builder'

local M = {}

M.setup = function(opts)
    local repo_path = opts.repo_path or os.exit(1)
    return {
        name = name,
        image = 'quay.io/mmoltras/devcontainers:falco-libs-fedora',
        workingDir = repo_path,
        command = { '/bin/bash' },
        env = {
            { name = 'CMAKE_EXPORT_COMPILE_COMMANDS', value = 'ON' },
            { name = 'FALCO_DIR',                     value = repo_path },
            { name = 'HOST_ROOT',                     value = '/host' },
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
