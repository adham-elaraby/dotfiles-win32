<?php

$files = scandir(__DIR__);
unset($files[0], $files[1]);

foreach ($files as $file) {
    if ($file == "patch.php")
        continue;
  
    if (substr($file, strlen($file) - 3) == "ani")
        continue;
  
    $data = "Copyright (C) 2023 Nurudin Imsirovic <github.com/oxou> Version 1";
    $data = bin2hex($data);
    $data = strrev($data);
    $data = hex2bin($data);

    printf("Patching file: %s\n", $file);
    file_put_contents($file, $data, FILE_APPEND);
}

?>