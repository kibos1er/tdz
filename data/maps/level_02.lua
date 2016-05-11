local map = ...

sol.main.load_file("td")(map)

waves = {
-- delay, { breed,                number, speed, delay,  HP,  rupees }       
    5000, {"tentacle",                 5,    32,  1000,  20,       2 },
   10000, {"blue_hardhat_beetle",      5,    64,  1000,  10,       1 },
   10000, {"red_hardhat_beetle",       5,    20,  1000,  60,       3 },
   10000, {"tentacle",                10,    32,  1000,  20,       2 },
   10000, {"blue_hardhat_beetle",     10,    64,  1000,  10,       1 },
   10000, {"red_hardhat_beetle",      10,    20,  1000,  60,       3 },
}

money = 200
