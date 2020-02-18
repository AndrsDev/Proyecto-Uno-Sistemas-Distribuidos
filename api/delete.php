<?php
    $balances_path = "balances.txt";
    $balances_file = fopen($balances_path, "w") or die("Unable to open file!");;
    fclose($balances_file);
?>