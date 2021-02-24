Config = {}

Config['URL'] = 'https://www.youtube.com/embed/%s?autoplay=1&controls=1&disablekb=1&fs=0&rel=0&showinfo=0&iv_load_policy=3&start=%s'
Config['URL2'] = 'https://trovo.live/embed/player?streamername=%s&muted=0&fullscreen=1&hidecontrol=1&autoplay=1&hidefollow=1&hidesub=1'
--Config['URL'] = 'https://www.youtube.com/watch?v=%s&t=%s' -- use this if you want to be able to play copyrighted stuff. please note that ads will pop up every now and again, and full screen doesn't work
Config['API'] = {
    ['URL'] = 'https://www.googleapis.com/youtube/v3/videos?id=%s&part=contentDetails&key=%s',
    ['Key'] = ''
}
Config['DurationCheck'] = false -- this will automatically delete the browser (good for ram i guess?) once the video has finished (REQUIRES YOU TO ADD AN API KEY!!!!!)

Config['Objects'] = {
    {
        ['Object'] = 'prop_tv_flat_01',
        ['Scale'] = 0.05,
        ['Offset'] = vec3(-0.925, -0.055, 1.0),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_michael',
        ['Scale'] = 0.035,
        ['Offset'] = vec3(-0.675, -0.055, 0.4),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_trev_tv_01',
        ['Scale'] = 0.012,
        ['Offset'] = vec3(-0.225, -0.01, 0.26),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_03b',
        ['Scale'] = 0.016,
        ['Offset'] = vec3(-0.3, -0.062, 0.18),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_03',
        ['Scale'] = 0.016,
        ['Offset'] = vec3(-0.3, -0.01, 0.4),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_02b',
        ['Scale'] = 0.026,
        ['Offset'] = vec3(-0.5, -0.012, 0.525),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_02',
        ['Scale'] = 0.030,
        ['Offset'] = vec3(-0.54, -0.012, 0.555),
        ['Distance'] = 7.5,
    }
}

Strings = {
    ['VideoHelp'] = 'Upisite ~b~/tv ~y~youtube URL~s~ da pustite video.\nPrimjer: ~b~/tv ~y~https://www.youtube.com/watch?v=hTDb0ebFh8E ~s~\nUpisite ~b~/trovo ~y~ime streamera~s~ da pustite trovo live.\nPrimjer: ~b~/trovo ~y~_Puja_ ~s~',
    ['VolumeHelp'] = 'Upisite ~b~/glasnoca ~y~(0-10)~s~ da promjenite glasnocu.\nPrimjer: ~b~/glasnoca ~y~5~s~\n\nUpisite ~b~/tv ~y~youtube URL~s~ da promjenite video.\nPrimjer: ~b~/tv ~y~https://www.youtube.com/watch?v=hTDb0ebFh8E ~s~\nUpisite ~b~/trovo ~y~ime streamera~s~ da promjenite na trovo live.\nPrimjer: ~b~/trovo ~y~Puhi ~s~\n\nUpisite ~b~/ugasitv~s~ da pekinete video\n\n~INPUT_CONTEXT~ Da sinkronizirate vrijeme',
}