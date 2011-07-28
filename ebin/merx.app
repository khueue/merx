{application, merx,
    [
        {description, "Simple One-Off File Transfer"},
        {vsn, "0.0.1"},
        {modules, [
            merx_app,
            merx_sup]},
        {registered, [merx_sup]},
        {applications, [kernel,stdlib]},
        {mod, {merx_app,[]}}
    ]}.
