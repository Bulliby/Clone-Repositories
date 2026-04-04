<?php

$ch = curl_init();

curl_setopt($ch, CURLOPT_URL, "https://api.github.com/user/repos?per_page=200");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (X11; Linux x86_64; rv:131.0) Gecko/20100101 Firefox/131.0");
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Authorization: Bearer '. $_SERVER['TOKEN'], 
    'X-GitHub-Api-Version: 2022-11-28'
]);

if(!$json = curl_exec($ch))
{
    trigger_error(curl_error($ch));
}

$data = json_decode($json);

if (!$data) {
    throw new \Exception('Json formating error');
}

$status = (!is_array($data) && $data->status) ? $data->status : null;

if ($status && $status != 200) {
    printf("%d %s\n", $data->status, $data->message);
    exit(1);
}

foreach($data as $repo) {
    printf("%s|%s\n", $repo->language ?? 'Unknown', $repo->ssh_url);
}

exit(0);
