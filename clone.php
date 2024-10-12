<?php

$ch = curl_init();

curl_setopt($ch, CURLOPT_URL, "https://api.github.com/user/repos?per_page=200");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (X11; Linux x86_64; rv:131.0) Gecko/20100101 Firefox/131.0");
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Authorization: Bearer '. $_SERVER['TOKEN'], 
    'X-GitHub-Api-Version: 2022-11-28'
]);

$json = curl_exec($ch);

$data = json_decode($json, true);

foreach($data as $repo) {
    echo (empty($repo['language']) ? 'Unknown' : $repo['language']) . ' ' . $repo['ssh_url'] . PHP_EOL;
}
