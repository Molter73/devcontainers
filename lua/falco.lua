local name = 'falco-builder'

local M = {}

M.setup = function(opts)
    local repo_path = opts.repo_path or os.exit(1)
    return {
        name = name,
        image = 'quay.io/mmoltras/devcontainers:falco-libs',
        workingDir = repo_path,
        command = { '/bin/bash' },
        env = {
            { name = 'CMAKE_EXPORT_COMPILE_COMMANDS', value = 'ON' },
            { name = 'FALCO_DIR',                     value = repo_path },
            { name = 'LIBS_DIR',                      value = repo_path .. '/../libs' },
            { name = 'HOST_ROOT',                     value = '/host' },
        },
        volumeMounts = opts.volumes or {},
        securityContext = {
            privileged = true,
            runAsUser = opts.user,
            runAsGroup = opts.group,
        },
        stdin = true,
        tty = true,
    }
end

M.volume_claim = function()
    return {
        apiVersion = 'v1',
        kind = 'PersistentVolumeClaim',
        metadata = { name = 'falco-ccache', },
        spec = {
            accessModes = { 'ReadWriteOnce' },
            resources = { requests = { storage = '5Gi' } },
        },
    }
end

return M
