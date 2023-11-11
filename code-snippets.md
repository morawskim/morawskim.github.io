# Code snippets

## Jak długo potrwa przetworzenie X wiadomości z kolejki

```
<?php

function calculateTotalTimeToProcessTasks($numberOfTasks, $avgProcessingTime, $firstTaskStartAtSecond = 0)
{
    $totalTime = 0;

    for ($i = 1; $i <= $numberOfTasks; $i++) {
        $totalTime += $firstTaskStartAtSecond + $avgProcessingTime * $i;
    }

    return $totalTime;
}

function howLongTakeToProcessing(int $numberOfInstances, int $queueSize, int $avgPrecessingTimeInSec) {
    $jobsInFirstStage = floor($queueSize / $numberOfInstances);
    $jobsInSecondStage = $queueSize % $numberOfInstances;

    $totalTime = $numberOfInstances * calculateTotalTimeToProcessTasks($jobsInFirstStage, $avgPrecessingTimeInSec);

    if ($jobsInSecondStage > 0) {
        $totalTime += $jobsInSecondStage * calculateTotalTimeToProcessTasks(1, $avgPrecessingTimeInSec, $avgPrecessingTimeInSec+($jobsInFirstStage-1)*$avgPrecessingTimeInSec);
    }


    return $totalTime / $queueSize;
}

var_dump(
    $time = howLongTakeToProcessing(4, 35, 3),
    round($time, 2) == 14.66
);
var_dump(
    $time = howLongTakeToProcessing(7, 35, 3),
    round($time, 2) == 9
);
```
