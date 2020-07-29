Config = {
  Version = 1.00,             -- Notifies you of updates.

  UseESX = true,              -- Are you using ESX?
  BankAccountName = "bank",   -- ESX account name for bank.

  DroneSounds = true,        -- Should the drones make sound?

  MaxVelocity = 250.0,        -- Max drone speed (* drone stats.speed)
  BoostSpeed  = 3.0,          -- How much the boost ability multiplies max speed
  BoostAccel  = 2.0,          -- How much the boost ability multiplies acceleration
  BoostDrain  = 1.0,          -- Boost ability drain speed when used
  BoostFill   = 0.2,          -- Boost ability recharge speed.
  TazerFill   = 0.2,          -- Tazer ability recharge speed.

  InteractDist   = 3.0,       -- Inside shop distance for help text

  Shop = {   
    -- Blip stuff should all be self-explainatory.                
    show_blip   = false,
    blip_sprite = 627,
    blip_color  = 2,
    blip_scale  = 0.8,
    blip_text   = "Drone Shop",
    blip_disp   = 2,
    location    = vector4(137.81024169922,-3092.6059570313,5.8963131904602,7.1427960395813),

    displays = {
      [1] = {
        spawn_table = true,                                                                   -- spawn a table here aswell?
        drone_tier  = 1,                                                                      -- drone tier, related to Config.Drones table below.
        position    = vector4(127.48832702637,-3081.9638671875,4.9245405197144,0.0),          -- display location
        droneoffset = vector3(0.0,0.0,1.5),                                                   -- drone spawn offset
        camoffset2  = vector3(0.0,0.0,1.85),                                                  -- display camera offset 1
        camoffset1  = vector3(0.12,0.4,1.5),                                                  -- display camera offset 2
      },
      [2] = {
        spawn_table = true,
        drone_tier  = 2,
        position    = vector4(133.81838989258,-3081.9638671875,4.8963103294373,0.0),
        droneoffset = vector3(0.0,0.0,1.5),
        camoffset2  = vector3(0.0,0.0,1.85),
        camoffset1  = vector3(0.12,0.4,1.5),
      },
      [3] = {
        spawn_table = true,
        drone_tier  = 3,
        position    = vector4(139.91311645508,-3081.9638671875,4.8963103294373,0.0),
        droneoffset = vector3(0.0,0.0,1.5),
        camoffset2  = vector3(0.0,0.0,1.85),
        camoffset1  = vector3(0.12,0.4,1.5),
      },
      [4] = {
        spawn_table = true,
        drone_tier  = 4,
        position    = vector4(145.83451843262,-3081.9638671875,4.8963103294373,0.0),
        droneoffset = vector3(0.0,0.0,1.5),
        camoffset2  = vector3(0.0,0.0,1.85),
        camoffset1  = vector3(0.12,0.4,1.5),
      },

      [5] = {
        spawn_table = true,
        drone_tier  = 4,
        position    = vector4(127.48832702637,-3086.9638671875,4.9245405197144,0.0),
        droneoffset = vector3(0.0,0.0,1.5),
        camoffset2  = vector3(0.0,0.0,1.85),
        camoffset1  = vector3(0.12,0.4,1.5),
      },
      [6] = {
        spawn_table = true,
        drone_tier  = 3,
        position    = vector4(133.81838989258,-3086.9638671875,4.8963103294373,0.0),
        droneoffset = vector3(0.0,0.0,1.5),
        camoffset2  = vector3(0.0,0.0,1.85),
        camoffset1  = vector3(0.12,0.4,1.5),
      },
      [7] = {
        spawn_table = true,
        drone_tier  = 2,
        position    = vector4(139.91311645508,-3086.9638671875,4.8963103294373,0.0),
        droneoffset = vector3(0.0,0.0,1.5),
        camoffset2  = vector3(0.0,0.0,1.85),
        camoffset1  = vector3(0.12,0.4,1.5),
      },
      [8] = {
        spawn_table = true,
        drone_tier  = 1,
        position    = vector4(145.83451843262,-3086.9638671875,4.8963103294373,0.0),
        droneoffset = vector3(0.0,0.0,1.5),
        camoffset2  = vector3(0.0,0.0,1.85),
        camoffset1  = vector3(0.12,0.4,1.5),
      },


      [9] = {
        spawn_table = true,
        drone_tier  = 5,
        position    = vector4(127.48832702637,-3091.9638671875,4.9357295036316,180.0),
        droneoffset = vector3(0.0,0.0,1.5),
        camoffset2  = vector3(0.0,0.0,1.85),
        camoffset1  = vector3(0.12,0.4,1.5),
      },
      [10] = {
        spawn_table = true,
        drone_tier  = 6,
        position    = vector4(133.81838989258,-3091.9638671875,4.8963060379028,180.0),
        droneoffset = vector3(0.0,0.0,1.5),
        camoffset2  = vector3(0.0,0.0,1.85),
        camoffset1  = vector3(0.12,0.4,1.5),
      },
      [11] = {
        spawn_table = true,
        drone_tier  = 6,
        position    = vector4(139.91311645508,-3091.9638671875,4.8963069915771,180.0),
        droneoffset = vector3(0.0,0.0,1.5),
        camoffset2  = vector3(0.0,0.0,1.85),
        camoffset1  = vector3(0.12,0.4,1.5),
      },
      [12] = {
        spawn_table = true,
        drone_tier  = 6,
        position    = vector4(145.83451843262,-3091.9638671875,4.8963069915771,180.0),
        droneoffset = vector3(0.0,0.0,1.5),
        camoffset2  = vector3(0.0,0.0,1.85),
        camoffset1  = vector3(0.12,0.4,1.5),
      },

      [13] = {
        spawn_table = true,
        drone_tier  = 5,
        position    = vector4(145.83451843262,-3096.9638671875,4.8963069915771,180.0),
        droneoffset = vector3(0.0,0.0,1.5),
        camoffset2  = vector3(0.0,0.0,1.85),
        camoffset1  = vector3(0.12,0.4,1.5),
      },
      [14] = {
        spawn_table = true,
        drone_tier  = 6,
        position    = vector4(139.91311645508,-3096.9638671875,4.8963069915771,180.0),
        droneoffset = vector3(0.0,0.0,1.5),
        camoffset2  = vector3(0.0,0.0,1.85),
        camoffset1  = vector3(0.12,0.4,1.5),
      },
      [15] = {
        spawn_table = true,
        drone_tier  = 6,
        position    = vector4(133.81838989258,-3096.9638671875,4.8963060379028,180.0),
        droneoffset = vector3(0.0,0.0,1.5),
        camoffset2  = vector3(0.0,0.0,1.85),
        camoffset1  = vector3(0.12,0.4,1.5),
      },
      [16] = {
        spawn_table = true,
        drone_tier  = 7,
        position    = vector4(127.48832702637,-3096.9638671875,4.9357295036316,180.0),
        droneoffset = vector3(0.0,0.0,1.0),
        camoffset2  = vector3(0.0,0.0,1.9),
        camoffset1  = vector3(0.2,1.0,1.4),
      },
    }
  },

  Drones = {
    [1] = {
      label = "Policijski Dron",
      name = "drone_flyer_7",
      public = false,
      price = 10000,
      model = GetHashKey('ch_prop_casino_drone_02a'),
      stats = {
        speed   = 1.0,
        agility = 1.0,
        range   = 200.0,

        maxSpeed    = 2,
        maxAgility  = 2,
        maxRange    = 200,
      },
      abilities = {
        infared     = true,
        nightvision = true,
        boost       = false,
        tazer       = false,
        explosive   = false,
      },
      restrictions = {
        'sipa'
      },
      bannerUrl = "banner1.png";
    },
  },

  Controls = {
    Drone = {
      ["inspect"] = {
        codes = {38},
        text = "Inspect",
      },
      ["direction"] = {
        codes = {32,33,34,35},
        text = "Smjer",
      },
      ["heading"] = {
        codes = {51,52},
        text = "Rotacija",
      },
      ["height"] = {
        codes = {21,22},
        text = "Visina",
      },
      ["camera"] = {
        codes = {108,110,109,111},
        text = "Kamera",
      },
      ["centercam"] = {
        codes = {214},
        text = "Centriraj kameru",
      },
      ["zoom"] = {
        codes = {16,17},
        text = "Zumiraj"
      },
      ["nightvision"] = {
        codes = {140},
        text = "Nightvision"
      },
      ["infared"] = {
        codes = {75},
        text = "Infared"
      },
      ["tazer"] = {
        codes = {157},
        text = "Shock"
      },
      ["explosive"] = {
        codes = {158},
        text = "Explode"
      },
      ["boost"] = {
        codes = {160},
        text = "Boost"
      },
      ["home"] = {
        codes = {213},
        text = "Kuca",
      },
      ["disconnect"] = {
        codes = {200},
        text = "Odspoji"
      },
    },
    Homing = {
      ["cancel"] = {
        codes = {213},
        text = "Prekini",
      },
      ["disconnect"] = {
        codes = {200},
        text = "Odspoji"
      },
    }
  },
}

mLibs = exports["meta_libs"]

if Config.UseESX then
  TriggerEvent("esx:getSharedObject", function(obj) ESX = obj; end)
end