-- Uploaded backgrounds, matched against the final local PNG pixels.
-- Each key identifies the original court geometry; incomplete sets are omitted.
mapBackgrounds = {}
do
local catalog = {
  -- 4T-4-vivantes/water-cannon
  ["511300641-6322-52"] = {pieces={{"1a0d9c125ad.png",-1380,-1000,1},{"1a0d9c7fd5d.png",800,-1000,1}}},
  -- 4T-3-vivantes/water-cannon
  ["1317108441-58308-47"] = {pieces={{"1a0da18d36b.png",-1380,-1000,1},{"1a0da1875a5.png",600,-1000,1}}},
  -- 4T-2-vivantes/water-cannon
  ["1787514854-44520-42"] = {pieces={{"1a0cfa9fb01.png",-1380,-1000,1},{"1a0cfa76687.png",400,-1000,1}}},
  -- 4T-4-vivantes/ice-barrier
  ["1255615608-31934-36"] = {pieces={{"1a0d9d4f522.png",-1380,-1000,1},{"1a0d9d5229d.png",-1380,200,1},{"1a0d9d55183.png",800,-1000,1},{"1a0d9d37ca7.png",800,200,1}}},
  -- 4T-3-vivantes/ice-barrier
  ["33464961-16018-30"] = {pieces={{"1a0d9bd12cc.png",-1380,-1000,1},{"1a0da39771b.png",-1380,200,1},{"1a0da39d4e1.png",600,-1000,1},{"1a0da39a600.png",600,200,1}}},
  -- 4T-2-vivantes/ice-barrier
  ["1621442174-60348-22"] = {pieces={{"1a0cfc119f7.png",-1380,-1000,1},{"1a0cfc017fa.png",-1380,200,1},{"1a0cfc0a49f.png",400,-1000,1},{"1a0da60a9d2.png",400,200,1}}},
  -- 4T-4-vivantes/sky-circles
  ["2104810837-42608-39"] = {pieces={{"1a0d9cb6219.png",-1380,-1000,1},{"1a0d9cf29f8.png",-1380,200,1},{"1a0d9ce9d46.png",800,-1000,1},{"1a0d9d044e6.png",800,200,1}}},
  -- 4T-3-vivantes/sky-circles
  ["718434695-26197-33"] = {pieces={{"1a0da207295.png",-1380,-1000,1},{"1a0da1f41cd.png",-1380,200,1},{"1a0da20d05b.png",600,-1000,1},{"1a0da1f70b6.png",600,200,1}}},
  -- 4T-2-vivantes/sky-circles
  ["1487777147-1304-24"] = {pieces={{"1a0cfac1ebe.png",-1380,-1000,1},{"1a0cfadd65b.png",-1380,200,1},{"1a0cfae6470.png",400,-1000,1},{"1a0cfab8b8e.png",400,200,1}}},
  -- 4T-4-vivantes/sky-trampolines
  ["989426023-86-50"] = {pieces={{"1a0d9ce85d1.png",-1380,-1000,1},{"1a0d9d02d6e.png",-1380,200,1},{"1a0d9cfb835.png",800,-1000,1},{"1a0d9cb4aa6.png",800,200,1}}},
  -- 4T-3-vivantes/sky-trampolines
  ["888612367-42418-41"] = {pieces={{"1a0da614de9.png",-1380,-1000,1},{"1a0da61abad.png",-1380,200,1},{"1a0da61f30b.png",600,-1000,1},{"1a0da61dc19.png",600,200,1}}},
  -- 4T-2-vivantes/sky-trampolines
  ["1381927082-14116-29"] = {pieces={{"1a0cfad49af.png",-1380,-1000,1},{"1a0cfadbede.png",-1380,200,1},{"1a0cfae4cff.png",400,-1000,1},{"1a0cfac0752.png",400,200,1}}},
  -- 4T-4-vivantes/bounce-diamonds
  ["1241378045-39248-39"] = {pieces={{"1a0da063e5a.png",-1380,-1000,1},{"1a0da05df67.png",-1380,200,1},{"1a0da09a7f9.png",800,-1000,1},{"1a0da0932c6.png",800,200,1}}},
  -- 4T-3-vivantes/bounce-diamonds
  ["1863983187-20962-32"] = {pieces={{"1a0da48e2c4.png",-1380,-1000,1},{"1a0da486d8f.png",-1380,200,1},{"1a0da479a8d.png",600,-1000,1},{"1a0da47255e.png",600,200,1}}},
  -- 4T-4-vivantes/black-water
  ["29804111-31793-36"] = {pieces={{"1a0da09d6de.png",-1380,-1000,1},{"1a0da097917.png",-1380,200,1},{"1a0da094a37.png",-290,200,1},{"1a0da0961a9.png",800,-1000,1},{"1a0da09bf73.png",800,200,1},{"1a0da099087.png",1890,200,1}}},
  -- 4T-3-vivantes/black-water
  ["1379230538-16022-30"] = {pieces={{"1a0da4c86ef.png",-1380,-1000,1},{"1a0da4911a2.png",-1380,200,1},{"1a0da48fa30.png",-390,200,1},{"1a0da488612.png",600,-1000,1},{"1a0da480fc1.png",600,200,1},{"1a0da4c5ffe.png",1590,200,1}}},
  -- 4T-2-vivantes/black-water
  ["642011180-58165-21"] = {pieces={{"1a0cfe4b86f.png",-1380,-1000,1},{"1a0cfe3b5d3.png",-1380,200,1},{"1a0cfe4427d.png",400,-1000,1},{"1a0d9971752.png",400,200,1}}},
  -- 4T-4-vivantes/top-player
  ["1601554952-40537-39"] = {pieces={{"1a0d9caa449.png",-1380,-1000,1},{"1a0d9ca2f0c.png",-1380,200,1},{"1a0d9c92d29.png",-290,200,1},{"1a0d9cabbb4.png",800,-1000,1},{"1a0d9c8b7f0.png",800,200,1},{"1a0d9c9a25e.png",1890,200,1}}},
  -- 4T-3-vivantes/top-player
  ["266979220-29267-35"] = {pieces={{"1a0da19bdd3.png",-1380,-1000,1},{"1a0da190243.png",-1380,200,1},{"1a0da198eeb.png",600,-1000,1},{"1a0da1977a4.png",600,200,1}}},
  -- 4T-2-vivantes/top-player
  ["445253453-126-24"] = {pieces={{"1a0cfa708d7.png",-1380,-1000,1},{"1a0cfa985c5.png",-1380,200,1},{"1a0cfaa58c3.png",400,-1000,1},{"1a0cfab2e26.png",400,200,1}}},
  -- 4T-3-vivantes/water-barrier
  ["983469419-23770-34"] = {pieces={{"1a0da194894.png",-1380,-1000,1},{"1a0da17a29a.png",-1380,200,1},{"1a0da19312d.png",600,-1000,1},{"1a0da1817cf.png",600,200,1}}},
  -- 4T-2-vivantes/water-barrier
  ["1016735131-64892-24"] = {pieces={{"1a0cfaae806.png",-1380,-1000,1},{"1a0cfa93f6e.png",-1380,200,1},{"1a0cfa6c3ba.png",400,-1000,1},{"1a0cfa6ac81.png",400,200,1}}},
  -- 4T-4-vivantes/cowebs
  ["1963181140-43286-41"] = {pieces={{"1a0da0581a1.png",-1380,-1000,1},{"1a0da0654fa.png",-1380,200,1},{"1a0da05f6c9.png",-290,200,1},{"1a0da06b2ca.png",800,-1000,1},{"1a0da08d500.png",800,200,1},{"1a0da089067.png",1890,200,1}}},
  -- 4T-3-vivantes/cowebs
  ["1945054654-25171-34"] = {pieces={{"1a0da4580b6.png",-1380,-1000,1},{"1a0da3fda40.png",-1380,200,1},{"1a0da45f496.png",600,-1000,1},{"1a0da3f4d45.png",600,200,1}}},
  -- 4T-2-vivantes/cowebs
  ["1993190275-64997-24"] = {pieces={{"1a0cfe26dad.png",-1380,-1000,1},{"1a0cfe1e108.png",-1380,200,1},{"1a0cfe2e2e5.png",400,-1000,1},{"1a0cfe3581e.png",400,200,1}}},
  -- 4T-4-vivantes/ice-angle
  ["581305930-42398-40"] = {pieces={{"1a0d9d50bac.png",-1380,-1000,1},{"1a0d9d5af4c.png",-1380,200,1},{"1a0d9d53a15.png",800,-1000,1},{"1a0d9d5806c.png",800,200,1}}},
  -- 4T-3-vivantes/ice-angle
  ["794736983-24134-33"] = {pieces={{"1a0d9bbb29f.png",-1380,-1000,1},{"1a0d9bc280b.png",-1380,200,1},{"1a0d9bcb510.png",600,-1000,1},{"1a0d9bd2a41.png",600,200,1}}},
  -- 4T-2-vivantes/ice-angle
  ["340925034-5743-26"] = {pieces={{"1a0cfc02f6f.png",-1380,-1000,1},{"1a0cfc1a69e.png",-1380,200,1},{"1a0cfc0bc0e.png",400,-1000,1},{"1a0cfbfa2b9.png",400,200,1}}},
  -- 4T-4-vivantes/spin-trampolines
  ["1059313160-43904-40"] = {pieces={{"1a0d9ce571e.png",-1380,-1000,1},{"1a0d9cf7072.png",-1380,200,1},{"1a0d9cb1bbe.png",800,-1000,1},{"1a0d9cf58dc.png",800,200,1}}},
  -- 4T-3-vivantes/spin-trampolines
  ["3028665-24963-33"] = {pieces={{"1a0da1df99c.png",-1380,-1000,1},{"1a0da1d9d60.png",-1380,200,1},{"1a0da1e6ed3.png",600,-1000,1},{"1a0da1a4a72.png",600,200,1}}},
  -- 4T-4-vivantes/the-floor-is-lava
  ["1499850571-53211-44"] = {pieces={{"1a0d9c95c13.png",-1380,-1000,1},{"1a0d9ca4689.png",-1380,200,1},{"1a0d9c9d142.png",800,-1000,1},{"1a0d9c8e6db.png",800,200,1}}},
  -- 4T-3-vivantes/the-floor-is-lava
  ["1086810883-32255-36"] = {pieces={{"1a0da1e5764.png",-1380,-1000,1},{"1a0da1a0420.png",-1380,200,1},{"1a0da1ecc92.png",600,-1000,1},{"1a0da19d543.png",600,200,1}}},
  -- 4T-2-vivantes/the-floor-is-lava
  ["969611748-13931-29"] = {pieces={{"1a0cfab5ca4.png",-1380,-1000,1},{"1a0cfa8e1ae.png",-1380,200,1},{"1a0cfa9b4a1.png",400,-1000,1},{"1a0cfaa7031.png",400,200,1}}},
  -- 4T-4-vivantes/choco-waters
  ["1846317034-31705-36"] = {pieces={{"1a0da0683dc.png",-1380,-1000,1},{"1a0da08a6dc.png",-1380,200,1},{"1a0da0903e7.png",800,-1000,1},{"1a0da060e43.png",800,200,1}}},
  -- 4T-3-vivantes/choco-waters
  ["2131679833-16288-30"] = {pieces={{"1a0da634d5d.png",-1380,-1000,1},{"1a0da46b021.png",-1380,200,1},{"1a0da630705.png",600,-1000,1},{"1a0da460c03.png",600,200,1}}},
  -- 4T-2-vivantes/choco-waters
  ["511231862-58082-21"] = {pieces={{"1a0cfe386ef.png",-1380,-1000,1},{"1a0cfe2fa54.png",-1380,200,1},{"1a0cfe20fe1.png",400,-1000,1},{"1a0cfe1845e.png",400,200,1}}},
  -- 4T-4-vivantes/twin-trampolines
  ["691402623-63900-47"] = {pieces={{"1a0d9c9738a.png",-1380,-1000,1},{"1a0d9c8fe4c.png",-1380,200,1},{"1a0d9ca002a.png",800,-1000,1},{"1a0d9ca8cd7.png",800,200,1}}},
  -- 4T-3-vivantes/twin-trampolines
  ["1458537000-50256-42"] = {pieces={{"1a0d999a819.png",-1380,-1000,1},{"1a0d9968cd3.png",-1380,200,1},{"1a0d9978c81.png",600,-1000,1},{"1a0da611f0c.png",600,200,1}}},
  -- 4T-2-vivantes/twin-trampolines
  ["996910509-36323-37"] = {pieces={{"1a0cfa89dfb.png",-1380,-1000,1},{"1a0cfa6d9e9.png",-1380,200,1},{"1a0cfab1652.png",400,-1000,1},{"1a0cfaa29dc.png",400,200,1}}},
  -- 4T-3-vivantes/black-pond
  ["1122741249-15945-30"] = {pieces={{"1a0da4cfc27.png",-1380,-1000,1},{"1a0da4c49e2.png",-1380,200,1},{"1a0d9c16bdb.png",600,-1000,1},{"1a0da4c9e63.png",600,200,1}}},
  -- 4T-2-vivantes/black-pond
  ["958423611-58125-21"] = {pieces={{"1a0cfe3cd4f.png",-1380,-1000,1},{"1a0d996a251.png",-1380,200,1},{"1a0d9972ebb.png",400,-1000,1},{"1a0cfe459f2.png",400,200,1}}},
  -- 4T-4-vivantes/no-jump
  ["871101487-11952-28"] = {pieces={{"1a0d9d1d3f1.png",-1380,-1000,1},{"1a0d9d0a2a7.png",-1380,200,1},{"1a0d9d27ac5.png",800,-1000,1},{"1a0d9d117d6.png",800,200,1}}},
  -- 4T-3-vivantes/no-jump
  ["1189449156-3744-25"] = {pieces={{"1a0da324dfb.png",-1380,-1000,1},{"1a0da620a84.png",-1380,200,1},{"1a0da31bec5.png",600,-1000,1},{"1a0da62396e.png",600,200,1}}},
  -- 4T-2-vivantes/no-jump
  ["795542110-53313-19"] = {pieces={{"1a0cfae3593.png",-1380,-1000,1},{"1a0cfada775.png",-1380,200,1},{"1a0cfaeaac2.png",400,-1000,1},{"1a0cfad3243.png",400,200,1}}},
  -- 4T-3-vivantes/honeymoon
  ["1023816945-42085-40"] = {pieces={{"1a0da3ded98.png",-1380,-1000,1},{"1a0da39ec5b.png",-1380,200,1},{"1a0da3d60ee.png",600,-1000,1},{"1a0da3cd4f3.png",600,200,1}}},
  -- 4T-2-vivantes/honeymoon
  ["1224312110-23038-33"] = {pieces={{"1a0cfc1be17.png",-1380,-1000,1},{"1a0cfbfba2e.png",-1380,200,1},{"1a0cfc046da.png",400,-1000,1},{"1a0cfc13188.png",400,200,1}}},
  -- 4T-4-vivantes/collision
  ["1347981057-24025-33"] = {pieces={{"1a0da08ec7c.png",-1380,-1000,1},{"1a0da066c79.png",-1380,200,1},{"1a0da05b080.png",800,-1000,1},{"1a0da059916.png",800,200,1}}},
  -- 4T-3-vivantes/collision
  ["1016435664-7889-27"] = {pieces={{"1a0da3f64af.png",-1380,-1000,1},{"1a0da4698b2.png",-1380,200,1},{"1a0da459713.png",600,-1000,1},{"1a0da3ff1b0.png",600,200,1}}},
  -- 4T-2-vivantes/collision
  ["1887650777-65058-24"] = {pieces={{"1a0cfe1f87c.png",-1380,-1000,1},{"1a0cfc264f9.png",-1380,200,1},{"1a0cfe2851d.png",400,-1000,1},{"1a0cfe36f7e.png",400,200,1}}},
  -- 4T-4-vivantes/snowy-mountains
  ["119963061-30534-61"] = {pieces={{"1a0d9cfa0be.png",-1380,-1000,1},{"1a0d9cefb14.png",-1380,200,1},{"1a0d9cf1295.png",800,-1000,1},{"1a0d9d015ff.png",800,200,1}}},
  -- 4T-3-vivantes/snowy-mountains
  ["903368474-7303-52"] = {pieces={{"1a0da61655f.png",-1380,-1000,1},{"1a0da61c657.png",-1380,200,1},{"1a0da617cd3.png",600,-1000,1},{"1a0da613679.png",600,200,1}}},
  -- 4T-2-vivantes/snowy-mountains
  ["1537626368-41603-40"] = {pieces={{"1a0da604c0f.png",-1380,-1000,1},{"1a0da607af0.png",-1380,200,1},{"1a0cfab7417.png",400,-1000,1},{"1a0da601d29.png",400,200,1}}},
  -- 4T-4-vivantes/halloween
  ["1350155980-24112-33"] = {pieces={{"1a0d9d5f59d.png",-1380,-1000,1},{"1a0da04396b.png",-1380,200,1},{"1a0da03db9c.png",800,-1000,1},{"1a0da03662a.png",800,200,1}}},
  -- 4T-3-vivantes/halloween
  ["1300850221-13470-29"] = {pieces={{"1a0d9bdea0a.png",-1380,-1000,1},{"1a0d9bd592c.png",-1380,200,1},{"1a0d9bc6eae.png",600,-1000,1},{"1a0d9bce3eb.png",600,200,1}}},
  -- 4T-2-vivantes/halloween
  ["1840287158-64752-24"] = {pieces={{"1a0cfc1604d.png",-1380,-1000,1},{"1a0cfc05e46.png",-1380,200,1},{"1a0cfbfe919.png",400,-1000,1},{"1a0cfc0ed69.png",400,200,1}}},
  -- 4T-4-vivantes/spooky-no-jump
  ["1903731991-9313-27"] = {pieces={{"1a0d9caee4d.png",-1380,-1000,1},{"1a0d9cfe70f.png",-1380,200,1},{"1a0d9ce4085.png",-290,200,1},{"1a0d9ca5df0.png",800,-1000,1},{"1a0d9cecc26.png",800,200,1},{"1a0d9cb044f.png",1890,200,1}}},
  -- 4T-3-vivantes/spooky-no-jump
  ["121079253-64048-23"] = {pieces={{"1a0d99a05db.png",-1380,-1000,1},{"1a0d99978dd.png",-1380,200,1},{"1a0d997ea49.png",600,-1000,1},{"1a0d998ec4a.png",600,200,1}}},
  -- 4T-2-vivantes/spooky-no-jump
  ["825754486-53026-19"] = {pieces={{"1a0da5f6310.png",-1380,-1000,1},{"1a0da5fa7f3.png",-1380,200,1},{"1a0da5fd6d2.png",400,-1000,1},{"1a0da5ef267.png",400,200,1}}},
  -- 4T-4-vivantes/eclipse
  ["185798889-27811-58"] = {pieces={{"1a0da037d90.png",-1380,-1000,1},{"1a0da04aea4.png",-1380,200,1},{"1a0d9d60d0a.png",800,-1000,1},{"1a0da0450dd.png",800,200,1}}},
  -- 4T-3-vivantes/eclipse
  ["746451074-63130-47"] = {pieces={{"1a0da462373.png",-1380,-1000,1},{"1a0da3dd628.png",-1380,200,1},{"1a0da3e62cd.png",600,-1000,1},{"1a0da62ef98.png",600,200,1}}},
  -- 4T-2-vivantes/eclipse
  ["875528437-44205-40"] = {pieces={{"1a0cfc177bc.png",-1380,-1000,1},{"1a0cfc1efbb.png",-1380,200,1},{"1a0cfc10284.png",400,-1000,1},{"1a0cfc075c4.png",400,200,1}}},
  -- 4T-4-vivantes/tube-cannon
  ["981421898-508-50"] = {pieces={{"1a0d9c8a085.png",-1380,-1000,1},{"1a0d9ca179a.png",-1380,200,1},{"1a0d9c915ba.png",800,-1000,1},{"1a0d9c98af0.png",800,200,1}}},
  -- 4T-3-vivantes/tube-cannon
  ["99676748-33139-37"] = {pieces={{"1a0d9993282.png",-1380,-1000,1},{"1a0d998a5d4.png",-1380,200,1},{"1a0d999bf85.png",600,-1000,1},{"1a0d998192b.png",600,200,1}}},
  -- 4T-2-vivantes/tube-cannon
  ["1353436214-9908-28"] = {pieces={{"1a0cfa96e4f.png",-1380,-1000,1},{"1a0cfa8b2c2.png",-1380,200,1},{"1a0cfa6f159.png",400,-1000,1},{"1a0cfaa4143.png",400,200,1}}},
  -- 4T-4-vivantes/ice-collision
  ["66564796-6556-26"] = {pieces={{"1a0d9d4506c.png",-1380,-1000,1},{"1a0d9d40955.png",-1380,200,1},{"1a0d9d46718.png",-290,200,1},{"1a0d9d33651.png",800,-1000,1},{"1a0d9d3ab8b.png",800,200,1},{"1a0d9d4c4db.png",1890,200,1}}},
  -- 4T-3-vivantes/ice-collision
  ["703387704-61332-22"] = {pieces={{"1a0da38a430.png",-1380,-1000,1},{"1a0da6250d0.png",-1380,200,1},{"1a0da62d826.png",-390,200,1},{"1a0da37736f.png",600,-1000,1},{"1a0da62c0b4.png",600,200,1},{"1a0da37e8a3.png",1590,200,1}}},
  -- 4T-2-vivantes/ice-collision
  ["1822746474-53285-19"] = {pieces={{"1a0cfbf5c76.png",-1380,-1000,1},{"1a0cfb01f35.png",-1380,200,1},{"1a0cfbed127.png",-490,200,1},{"1a0cfb0abd9.png",400,-1000,1},{"1a0cfaf1ffc.png",400,200,1},{"1a0cfbf73db.png",1290,200,1}}},
  -- 4T-4-vivantes/ice-booster
  ["265867957-54335-42"] = {pieces={{"1a0d9d34dc8.png",-1380,-1000,1},{"1a0d9d47e88.png",-1380,200,1},{"1a0d9d3c2fb.png",-290,200,1},{"1a0d9d36539.png",800,-1000,1},{"1a0d9d4dc4d.png",800,200,1},{"1a0d9d420c3.png",1890,200,1}}},
  -- 4T-3-vivantes/ice-booster
  ["943467518-34411-35"] = {pieces={{"1a0da398e8e.png",-1380,-1000,1},{"1a0da3930d0.png",-1380,200,1},{"1a0da39c068.png",-390,200,1},{"1a0da378adb.png",600,-1000,1},{"1a0da394841.png",600,200,1},{"1a0da395fa6.png",1590,200,1}}},
  -- 4T-2-vivantes/ice-booster
  ["48666429-20590-30"] = {pieces={{"1a0cfb0c348.png",-1380,-1000,1},{"1a0cfb0369d.png",-1380,200,1},{"1a0cfc18f32.png",-490,200,1},{"1a0cfbee750.png",400,-1000,1},{"1a0da609260.png",400,200,1},{"1a0cfbf8b50.png",1290,200,1}}},
  -- 4T-3-vivantes/light-dark
  ["1363039590-65305-46"] = {pieces={{"1a0da30bcde.png",-1380,-1000,1},{"1a0da31321d.png",-1380,200,1},{"1a0da326561.png",600,-1000,1},{"1a0da36e6c6.png",600,200,1}}},
  -- 4T-2-vivantes/light-dark
  ["628568408-39818-37"] = {pieces={{"1a0cfaf3770.png",-1380,-1000,1},{"1a0cfb04f66.png",-1380,200,1},{"1a0cfb0dabb.png",400,-1000,1},{"1a0cfbefea4.png",400,200,1}}},
  -- 4T-4-vivantes/volley-2-0
  ["1531039119-33629-36"] = {pieces={{"1a0da6393b1.png",-1380,-1000,1},{"1a0d9c88909.png",-1380,200,1},{"1a0d9ca7563.png",800,-1000,1},{"1a0da63ab1e.png",800,200,1}}},
  -- 4T-3-vivantes/volley-2-0
  ["1610133592-12440-28"] = {pieces={{"1a0da18ead4.png",-1380,-1000,1},{"1a0da17ba0c.png",-1380,200,1},{"1a0da188d06.png",600,-1000,1},{"1a0da182f3e.png",600,200,1}}},
  -- 4T-2-vivantes/volley-2-0
  ["1894748033-61372-22"] = {pieces={{"1a0cfaa1269.png",-1380,-1000,1},{"1a0cfaafedc.png",-1380,200,1},{"1a0cfa77e05.png",400,-1000,1},{"1a0cfa956ed.png",400,200,1}}},
  -- 4T-4-vivantes/pink-date
  ["1826231665-52288-44"] = {pieces={{"1a0da6437cf.png",-1380,-1000,1},{"1a0da6408e6.png",-1380,200,1},{"1a0da63f173.png",800,-1000,1},{"1a0da63da07.png",800,200,1},{"1a0d9d2c109.png",334,112,1,layer='!1000'},{"1a0d9d2c109.png",734,112,1,layer='!1000'},{"1a0d9d2c109.png",1134,112,1,layer='!1000'}}},
  -- 4T-3-vivantes/pink-date
  ["461852483-28897-35"] = {pieces={{"1a0da2f8c29.png",-1380,-1000,1},{"1a0da30015c.png",-1380,200,1},{"1a0da320787.png",600,-1000,1},{"1a0da3047b1.png",600,200,1},{"1a0d9d2c109.png",334,112,1,layer='!1000'},{"1a0d9d2c109.png",734,112,1,layer='!1000'}}},
  -- 4T-2-vivantes/pink-date
  ["1589179725-5173-26"] = {pieces={{"1a0cfabc373.png",-1380,-1000,1},{"1a0cfad035f.png",-1380,200,1},{"1a0cfae053c.png",400,-1000,1},{"1a0cfabd86c.png",400,200,1},{"1a0da329437.png",323,106,1,layer='!1000'}}},
  -- 4T-4-vivantes/kralizmox
  ["1935028562-15846-29"] = {pieces={{"1a0d9d29237.png",-1380,-1000,1},{"1a0d9d3076e.png",-1380,200,1},{"1a0d9d0d186.png",-290,200,1},{"1a0d9d12f55.png",800,-1000,1},{"1a0d9d1a47a.png",800,200,1},{"1a0d9d14943.png",1890,200,1}}},
  -- 4T-3-vivantes/kralizmox
  ["1550811378-4572-25"] = {pieces={{"1a0da380017.png",-1380,-1000,1},{"1a0da385de1.png",-1380,200,1},{"1a0da37a245.png",600,-1000,1},{"1a0da374486.png",600,200,1},{"1a0da38ea7d.png",1590,200,1}}},
  -- 4T-2-vivantes/kralizmox
  ["961490928-61509-22"] = {pieces={{"1a0cfb07cf6.png",-1380,-1000,1},{"1a0cfaed9ae.png",-1380,200,1},{"1a0cfbf2d8e.png",400,-1000,1},{"1a0cfaf4ee7.png",400,200,1}}},
  -- 4T-4-vivantes/the-rainbow
  ["45162040-19306-77"] = {pieces={{"1a0d9c9b9d4.png",-1380,-1000,1},{"1a0d9c9449c.png",-1380,200,1},{"1a0d9cad324.png",800,-1000,1},{"1a0d9c8cf60.png",800,200,1}}},
  -- 4T-3-vivantes/the-rainbow
  ["77715627-38410-60"] = {pieces={{"1a0da19a657.png",-1380,-1000,1},{"1a0d9984811.png",-1380,200,1},{"1a0da1a340e.png",600,-1000,1},{"1a0d998d4bc.png",600,200,1}}},
  -- 4T-2-vivantes/the-rainbow
  ["674080404-61395-45"] = {pieces={{"1a0cfa72038.png",-1380,-1000,1},{"1a0cfa8ca2e.png",-1380,200,1},{"1a0cfab452a.png",400,-1000,1},{"1a0cfa99d33.png",400,200,1}}},
  -- 4T-4-vivantes/platforms
  ["1831244232-61344-74"] = {pieces={{"1a0da642059.png",-1380,-1000,1},{"1a0da63c294.png",800,-1000,1}}},
  -- 4T-3-vivantes/platforms
  ["1912369198-19949-58"] = {pieces={{"1a0da2fbb0b.png",-1380,-1000,1},{"1a0da2f45d7.png",600,-1000,1}}},
  -- 4T-2-vivantes/platforms
  ["1960478565-49471-44"] = {pieces={{"1a0cfae7be5.png",-1380,-1000,1},{"1a0cfad7888.png",400,-1000,1}}},
  -- 4T-4-vivantes/some-chords
  ["1910961868-17324-29"] = {pieces={{"1a0d9ce6e5e.png",-1380,-1000,1},{"1a0d9cb332d.png",-290,-1000,1},{"1a0d9cffe88.png",-1380,200,1},{"1a0d9cf8b06.png",800,-1000,1},{"1a0d9cee395.png",800,200,1}}},
  -- 4T-3-vivantes/some-chords
  ["1375202986-5802-25"] = {pieces={{"1a0da1e112c.png",-1380,-1000,1},{"1a0da619441.png",-1380,200,1},{"1a0da1db34d.png",600,-1000,1},{"1a0da1a61e8.png",600,200,1}}},
  -- 4T-2-vivantes/some-chords
  ["1997224107-59875-21"] = {pieces={{"1a0da606394.png",-1380,-1000,1},{"1a0da5fee4f.png",-1380,200,1},{"1a0da6005bd.png",400,-1000,1},{"1a0da6034a9.png",400,200,1}}},
  -- 4T-3-vivantes/quad-cannons
  ["1289164141-42145-42"] = {pieces={{"1a0da2f175c.png",-1380,-1000,1},{"1a0da2fa392.png",-1380,200,1},{"1a0da2f2e59.png",-390,200,1},{"1a0da2116af.png",600,-1000,1},{"1a0da2f5d3b.png",600,200,1},{"1a0da3018c9.png",1590,200,1}}},
  -- 4T-2-vivantes/quad-cannons
  ["1418215341-33635-39"] = {pieces={{"1a0cfadedc0.png",-1380,-1000,1},{"1a0cfaba608.png",-1380,200,1},{"1a0cfac362d.png",400,-1000,1},{"1a0cfad6125.png",400,200,1}}},
  -- 4T-4-vivantes/default-map
  ["919598699-28963-34"] = {pieces={{"1a0da056a3f.png",-1380,-1000,1},{"1a0da053b4b.png",-1380,200,1},{"1a0da0523d2.png",800,-1000,1},{"1a0da050c6d.png",800,200,1}}},
  -- 4T-3-vivantes/default-map
  ["833579328-15288-29"] = {pieces={{"1a0da3f06eb.png",-1380,-1000,1},{"1a0da463ae6.png",-1380,200,1},{"1a0da40208f.png",600,-1000,1},{"1a0da3f9394.png",600,200,1}}},
  -- 4T-2-vivantes/default-map
  ["910414154-55942-20"] = {pieces={{"1a0cfe2cb72.png",-1380,-1000,1},{"1a0cfe2563d.png",-1380,200,1},{"1a0cfc24d79.png",400,-1000,1},{"1a0cfe1c995.png",400,200,1}}},
  -- 4T-4-vivantes/impostor
  ["1072698299-41822-40"] = {pieces={{"1a0d9d43839.png",-1380,-1000,1},{"1a0d9d2ab07.png",-1380,200,1},{"1a0d9d495f9.png",800,-1000,1},{"1a0d9d3da72.png",800,200,1}}},
  -- 4T-3-vivantes/impostor
  ["1638070039-21137-32"] = {pieces={{"1a0da3901ee.png",-1380,-1000,1},{"1a0da375bf5.png",-1380,200,1},{"1a0da37d135.png",600,-1000,1},{"1a0da382efb.png",600,200,1}}},
  -- 4T-2-vivantes/impostor
  ["1704795425-5839-26"] = {pieces={{"1a0cfbf44ff.png",-1380,-1000,1},{"1a0cfaef11e.png",-1380,200,1},{"1a0cfb109a7.png",400,-1000,1},{"1a0cfaf6655.png",400,200,1}}},
  -- 4T-4-vivantes/ocean
  ["1527176577-11680-28"] = {pieces={{"1a0d9d073bb.png",-1380,-1000,1},{"1a0d9d1005f.png",-1380,200,1},{"1a0d9d2d888.png",-290,200,1},{"1a0d9d0e8f1.png",800,-1000,1},{"1a0d9d08b2f.png",800,200,1},{"1a0d9d17599.png",1890,200,1}}},
  -- 4T-3-vivantes/ocean
  ["1077430992-681-24"] = {pieces={{"1a0da305f1b.png",-1380,-1000,1},{"1a0da317870.png",-1380,200,1},{"1a0da30ebc7.png",-390,200,1},{"1a0da307687.png",600,-1000,1},{"1a0da318fd6.png",600,200,1},{"1a0da6221ec.png",1590,200,1}}},
  -- 4T-2-vivantes/ocean
  ["1096865655-58884-21"] = {pieces={{"1a0cfad1acc.png",-1380,-1000,1},{"1a0cfae1d46.png",-1380,200,1},{"1a0cfabefd8.png",400,-1000,1},{"1a0cfad9006.png",400,200,1}}},
  -- 4T-4-vivantes/dusty-journey
  ["1587188712-8732-48"] = {pieces={{"1a0da046843.png",-1380,-1000,1},{"1a0da03f31a.png",-1380,200,1},{"1a0da039503.png",800,-1000,1},{"1a0da04c615.png",800,200,1}}},
  -- 4T-3-vivantes/dusty-journey
  ["2017524639-41915-38"] = {pieces={{"1a0d9bfdcb5.png",-1380,-1000,1},{"1a0d9be73e1.png",-1380,200,1},{"1a0d9bf5003.png",600,-1000,1},{"1a0d9be0043.png",600,200,1}}},
  -- 4T-2-vivantes/dusty-journey
  ["1251134541-30818-34"] = {pieces={{"1a0da60c14f.png",-1380,-1000,1},{"1a0cfc08d2d.png",-1380,200,1},{"1a0cfc20732.png",400,-1000,1},{"1a0cfc0008b.png",400,200,1}}},
  -- 4T-4-vivantes/departure
  ["1148044508-23278-56"] = {pieces={{"1a0da0421ed.png",-1380,-1000,1},{"1a0da04f4fa.png",-1380,200,1},{"1a0da033746.png",800,-1000,1},{"1a0da0552bb.png",800,200,1}}},
  -- 4T-3-vivantes/departure
  ["41367870-34427-57"] = {pieces={{"1a0d9bff425.png",-1380,-1000,1},{"1a0d9be2d8e.png",-1380,200,1},{"1a0d9c080d5.png",600,-1000,1},{"1a0d9bedad3.png",600,200,1}}},
  -- 4T-2-vivantes/departure
  ["420110573-34559-56"] = {pieces={{"1a0cfe23ecb.png",-1380,-1000,1},{"1a0cfe3409d.png",-1380,200,1},{"1a0cfe2b400.png",400,-1000,1},{"1a0cfc2360d.png",400,200,1}}},
  -- 4T-4-vivantes/simple-neon
  ["1173766353-12112-50"] = {pieces={{"1a0cfa4699a.png",-1380,-1000,1},{"1a0cfa48103.png",-1380,200,1},{"1a0cfa49880.png",800,-1000,1},{"1a0cfa4afea.png",800,200,1}}},
  -- 4T-3-vivantes/simple-neon
  ["140145077-57552-43"] = {pieces={{"1a0cfa40bda.png",-1380,-1000,1},{"1a0cfa42349.png",-1380,200,1},{"1a0cfa43abf.png",600,-1000,1},{"1a0cfa4522b.png",600,200,1}}},
  -- 4T-2-vivantes/simple-neon
  ["600319957-37260-36"] = {pieces={{"1a0cfa3dcff.png",-1380,-1000,1},{"1a0cfa3f466.png",400,-1000,1}}},
  -- 4T-4-vivantes/dragon-water
  ["1561675655-39058-38"] = {pieces={{"1a0da04dd86.png",-1380,-1000,1},{"1a0da03ac7b.png",-1380,200,1},{"1a0da047fb7.png",-290,200,1},{"1a0da040a7e.png",800,-1000,1},{"1a0da0320dc.png",800,200,1}}},
  -- 4T-3-vivantes/dragon-water
  ["963275648-11394-28"] = {pieces={{"1a0d9bec36a.png",-1380,-1000,1},{"1a0d9be1620.png",-1380,200,1},{"1a0d9bf677a.png",600,-1000,1},{"1a0d9c06968.png",600,200,1}}},
  -- 4T-2-vivantes/dragon-water
  ["354914538-62695-23"] = {pieces={{"1a0cfe3292b.png",-1380,-1000,1},{"1a0da60d8b7.png",-1380,200,1},{"1a0cfe1b21f.png",400,-1000,1},{"1a0cfc21ea3.png",400,200,1}}},
  -- 4T-4-vivantes/cherry-blossom
  ["1290976541-39740-39"] = {pieces={{"1a0da069b52.png",-1380,-1000,1},{"1a0da091b53.png",-290,-1000,1},{"1a0da062770.png",-1380,200,1},{"1a0da08bd9b.png",800,-1000,1},{"1a0da05c7fa.png",800,200,1}}},
  -- 4T-3-vivantes/cherry-blossom
  ["313291704-5628-26"] = {pieces={{"1a0da6335f7.png",-1380,-1000,1},{"1a0da637c42.png",-1380,200,1},{"1a0da631e7a.png",600,-1000,1},{"1a0da6364cf.png",600,200,1}}},
  -- 4T-2-vivantes/cherry-blossom
  ["1818935705-57608-21"] = {pieces={{"1a0cfe19b6a.png",-1380,-1000,1},{"1a0cfe311cc.png",-1380,200,1},{"1a0cfe39e5d.png",400,-1000,1},{"1a0cfe29c95.png",400,200,1}}},
  -- 4T-4-vivantes/yin-yang
  ["1988855872-39799-60"] = {pieces={{"1a0d9c85a33.png",-1380,-1000,1},{"1a0d9c1f889.png",-1380,200,1},{"1a0d9c10d84.png",800,-1000,1},{"1a0d9c7e649.png",800,200,1}}},
  -- 4T-3-vivantes/yin-yang
  ["240200155-30989-57"] = {pieces={{"1a0cfe4715f.png",-1380,-1000,1},{"1a0d996d0fe.png",-1380,200,1},{"1a0cfe4e755.png",600,-1000,1},{"1a0cfe3fc36.png",600,200,1}}},
  -- 4T-2-vivantes/yin-yang
  ["1680660502-41790-38"] = {pieces={{"1a0cfa68f80.png",-1380,-1000,1},{"1a0cfaad071.png",-1380,200,1},{"1a0cfa674df.png",400,-1000,1},{"1a0cfa927f8.png",400,200,1}}},
  -- 4T-4-vivantes/ice-wheel
  ["1288090053-6033-52"] = {pieces={{"1a0d9d394c2.png",-1380,-1000,1},{"1a0d9d3f1dc.png",-1380,200,1},{"1a0d9d31ee3.png",800,-1000,1},{"1a0d9d4ad65.png",800,200,1}}},
  -- 4T-3-vivantes/ice-wheel
  ["1319047903-40208-40"] = {pieces={{"1a0d9af487d.png",-1380,-1000,1},{"1a0d9afbdb6.png",-1380,200,1},{"1a0d9bb54dc.png",600,-1000,1},{"1a0d9baf741.png",600,200,1}}},
  -- 4T-2-vivantes/ice-wheel
  ["1610576830-17161-31"] = {pieces={{"1a0cfb12111.png",-1380,-1000,1},{"1a0cfaf0886.png",-1380,200,1},{"1a0cfb09648.png",400,-1000,1},{"1a0cfb00b97.png",400,200,1}}},
  -- 4T-4-vivantes/sabiro-fishes
  ["1830686295-54297-43"] = {pieces={{"1a0cfaaa331.png",-1380,-1000,1},{"1a0cfa9e384.png",-1380,200,1},{"1a0cfaab889.png",-290,200,1},{"1a0cfa65d70.png",800,-1000,1},{"1a0cfa74f1c.png",800,200,1},{"1a0cfa91084.png",1890,200,1}}},
  -- 4T-3-vivantes/sabiro-fishes
  ["906250125-29265-34"] = {pieces={{"1a0da5ec380.png",-1380,-1000,1},{"1a0cfa8f916.png",-1380,200,1},{"1a0cfa9cc12.png",-390,200,1},{"1a0da5edaf5.png",600,-1000,1},{"1a0cfa737ac.png",600,200,1},{"1a0cfaa879f.png",1590,200,1}}},
  -- 4T-2-vivantes/sabiro-fishes
  ["136691248-7037-26"] = {pieces={{"1a0cfa582f0.png",-1380,-1000,1},{"1a0cfa59aad.png",-1380,200,1},{"1a0cfa5b1d1.png",400,-1000,1},{"1a0cfa5c93e.png",400,200,1}}},
  -- 4T-4-vivantes/lava-bumpers
  ["1339350618-13674-56"] = {pieces={{"1a0cfe3e4bc.png",-1380,-1000,1},{"1a0cfe4cfe9.png",-1380,200,1},{"1a0d997462e.png",800,-1000,1},{"1a0d996b98b.png",800,200,1}}},
  -- 4T-3-vivantes/lava-bumpers
  ["871847179-59673-48"] = {pieces={{"1a0d9afec95.png",-1380,-1000,1},{"1a0d9af8f46.png",-1380,200,1},{"1a0d9af022e.png",600,-1000,1},{"1a0d9bb25f4.png",600,200,1}}},
  -- 4T-2-vivantes/lava-bumpers
  ["1189579043-23182-34"] = {pieces={{"1a0cfbf1615.png",-1380,-1000,1},{"1a0cfb0f231.png",-1380,200,1},{"1a0cfaec22f.png",400,-1000,1},{"1a0cfb065e0.png",400,200,1}}},
  -- Normal-Large/water-barrier
  ["2122258609-4952-26"] = {pieces={{"1a0da194894.png",-1380,-1000,1},{"1a0da17a29a.png",-1380,200,1},{"1a0da19312d.png",600,-1000,1},{"1a0da1817cf.png",600,200,1}}},
  -- Normal-Large/sky-circles
  ["1477308136-1901-24"] = {pieces={{"1a0da207295.png",-1380,-1000,1},{"1a0da1f41cd.png",-1380,200,1},{"1a0da20d05b.png",600,-1000,1},{"1a0da1f70b6.png",600,200,1}}},
  -- Normal-Small/edge-trampolines
  ["1091090761-8467-28"] = {pieces={{"1a0da563b6c.png",-1380,-1000,1},{"1a0da57cabe.png",-1380,200,1},{"1a0da56b0a5.png",400,-1000,1},{"1a0da5a0e29.png",400,200,1}}},
  -- Normal-Large/edge-trampolines
  ["1031981444-9635-28"] = {pieces={{"1a0da3ed808.png",-1380,-1000,1},{"1a0da3dbeb7.png",-1380,200,1},{"1a0da3d497b.png",600,-1000,1},{"1a0da3e4b5e.png",600,200,1}}},
  -- Normal-Small/hidden-blocks
  ["391272074-13488-28"] = {pieces={{"1a0da4f8db5.png",-1380,-1000,1},{"1a0da54c454.png",-1380,200,1},{"1a0da544f16.png",400,-1000,1},{"1a0da55f519.png",400,200,1}}},
  -- Normal-Large/hidden-blocks
  ["1735625165-27850-33"] = {pieces={{"1a0da3a03c8.png",-1380,-1000,1},{"1a0da3e7a42.png",-1380,200,1},{"1a0da3e0509.png",600,-1000,1},{"1a0da3cebb2.png",600,200,1}}},
  -- Normal-Large/water-cannon
  ["359639136-45139-42"] = {pieces={{"1a0da18d36b.png",-1380,-1000,1},{"1a0da1875a5.png",600,-1000,1}}},
  -- Normal-Large/default
  ["1417298003-58668-21"] = {pieces={{"1a0da3f06eb.png",-1380,-1000,1},{"1a0da463ae6.png",-1380,200,1},{"1a0da40208f.png",600,-1000,1},{"1a0da3f9394.png",600,200,1}}},
  -- Normal-Large/ice-barrier
  ["1768448475-477-24"] = {pieces={{"1a0d9bd12cc.png",-1380,-1000,1},{"1a0da39771b.png",-1380,200,1},{"1a0da39d4e1.png",600,-1000,1},{"1a0da39a600.png",600,200,1}}},
  -- Normal-Small/choco-floor
  ["245039273-56023-20"] = {pieces={{"1a0da59df42.png",-1380,-1000,1},{"1a0da578465.png",-1380,200,1},{"1a0da5681c1.png",400,-1000,1},{"1a0da5a6bec.png",400,200,1}}},
  -- Normal-Large/choco-floor
  ["1657347141-1170-24"] = {pieces={{"1a0da489cbd.png",-1380,-1000,1},{"1a0da47b201.png",-1380,200,1},{"1a0da475437.png",600,-1000,1},{"1a0da482737.png",600,200,1}}},
  -- Normal-Large/no-jump
  ["1301781552-53646-19"] = {pieces={{"1a0da324dfb.png",-1380,-1000,1},{"1a0da620a84.png",-1380,200,1},{"1a0da31bec5.png",600,-1000,1},{"1a0da62396e.png",600,200,1}}},
  -- Normal-Large/collision
  ["1102018813-63164-23"] = {pieces={{"1a0da3f64af.png",-1380,-1000,1},{"1a0da4698b2.png",-1380,200,1},{"1a0da459713.png",600,-1000,1},{"1a0da3ff1b0.png",600,200,1}}},
  -- Normal-Large/top-player
  ["1713614305-629-24"] = {pieces={{"1a0da19bdd3.png",-1380,-1000,1},{"1a0da190243.png",-1380,200,1},{"1a0da198eeb.png",600,-1000,1},{"1a0da1977a4.png",600,200,1}}},
  -- Normal-Small/inclined
  ["591573356-9885-27"] = {pieces={{"1a0da5550f9.png",-1380,-1000,1},{"1a0da5438df.png",-1380,200,1},{"1a0da55dda5.png",400,-1000,1},{"1a0da54acdf.png",400,200,1}}},
  -- Normal-Large/inclined
  ["407195134-12743-28"] = {pieces={{"1a0da388cb0.png",-1380,-1000,1},{"1a0da387547.png",-1380,200,1},{"1a0da37b9ba.png",600,-1000,1},{"1a0da381779.png",600,200,1}}},
  -- Normal-Large/sky-trampolines
  ["27868905-14468-30"] = {pieces={{"1a0da614de9.png",-1380,-1000,1},{"1a0da61abad.png",-1380,200,1},{"1a0da61f30b.png",600,-1000,1},{"1a0da61dc19.png",600,200,1}}},
  -- Normal-Large/spin-trampolines
  ["854156443-1368-24"] = {pieces={{"1a0da1df99c.png",-1380,-1000,1},{"1a0da1d9d60.png",-1380,200,1},{"1a0da1e6ed3.png",600,-1000,1},{"1a0da1a4a72.png",600,200,1}}},
  -- Normal-Large/black-water
  ["437068317-60893-22"] = {pieces={{"1a0da4c86ef.png",-1380,-1000,1},{"1a0da4911a2.png",-1380,200,1},{"1a0da48fa30.png",-390,200,1},{"1a0da488612.png",600,-1000,1},{"1a0da480fc1.png",600,200,1},{"1a0da4c5ffe.png",1590,200,1}}},
  -- Normal-Small/chaos
  ["1712287273-4398-52"] = {pieces={{"1a0da59f6b2.png",-1380,-1000,1},{"1a0da5a8360.png",-1380,200,1},{"1a0da579bd5.png",400,-1000,1},{"1a0da570e6e.png",400,200,1}}},
  -- Normal-Large/chaos
  ["1776885729-2174-51"] = {pieces={{"1a0da48b3e6.png",-1380,-1000,1},{"1a0da46df04.png",-1380,200,1},{"1a0da483ea6.png",600,-1000,1},{"1a0da47c973.png",600,200,1}}},
  -- Normal-Large/cowebs
  ["401819792-6781-27"] = {pieces={{"1a0da4580b6.png",-1380,-1000,1},{"1a0da3fda40.png",-1380,200,1},{"1a0da45f496.png",600,-1000,1},{"1a0da3f4d45.png",600,200,1}}},
  -- Normal-Large/the-floor-is-lava
  ["122964921-14474-29"] = {pieces={{"1a0da1e5764.png",-1380,-1000,1},{"1a0da1a0420.png",-1380,200,1},{"1a0da1ecc92.png",600,-1000,1},{"1a0da19d543.png",600,200,1}}},
  -- Normal-Large/choco-waters
  ["86253651-60805-22"] = {pieces={{"1a0da634d5d.png",-1380,-1000,1},{"1a0da46b021.png",-1380,200,1},{"1a0da630705.png",600,-1000,1},{"1a0da460c03.png",600,200,1}}},
  -- Normal-Large/bounce-diamonds
  ["1852460807-2562-25"] = {pieces={{"1a0da48e2c4.png",-1380,-1000,1},{"1a0da486d8f.png",-1380,200,1},{"1a0da479a8d.png",600,-1000,1},{"1a0da47255e.png",600,200,1}}},
  -- Normal-Large/honeymoon
  ["578030013-23555-33"] = {pieces={{"1a0da3ded98.png",-1380,-1000,1},{"1a0da39ec5b.png",-1380,200,1},{"1a0da3d60ee.png",600,-1000,1},{"1a0da3cd4f3.png",600,200,1}}},
  -- Normal-Large/black-pond
  ["1860394395-60853-22"] = {pieces={{"1a0da4cfc27.png",-1380,-1000,1},{"1a0da4c49e2.png",-1380,200,1},{"1a0d9c16bdb.png",600,-1000,1},{"1a0da4c9e63.png",600,200,1}}},
  -- Normal-Small/kst-small
  ["1453396622-15600-30"] = {pieces={{"1a0da55c634.png",-1380,-1000,1},{"1a0da4f763d.png",-1380,200,1},{"1a0da4feb78.png",400,-1000,1},{"1a0da553985.png",400,200,1}}},
  -- Normal-Large/kst-small
  ["2004433308-15967-30"] = {pieces={{"1a0da3715b0.png",-1380,-1000,1},{"1a0da38d308.png",-1380,200,1},{"1a0da316104.png",600,-1000,1},{"1a0da372d0e.png",600,200,1}}},
  -- Normal-Small/date
  ["1758659694-5496-26"] = {pieces={{"1a0da59c80b.png",-1380,-1000,1},{"1a0da566a4d.png",-490,-1000,1},{"1a0da575602.png",-1380,200,1},{"1a0da5a3d0c.png",400,-1000,1},{"1a0da56c819.png",400,200,1}}},
  -- Normal-Large/date
  ["682168558-8300-27"] = {pieces={{"1a0da3f1e5d.png",-1380,-1000,1},{"1a0da4669c5.png",-390,-1000,1},{"1a0da45c5ac.png",-1380,200,1},{"1a0da45dd1f.png",-390,200,1},{"1a0da465259.png",600,-1000,1},{"1a0da3fab01.png",600,200,1},{"1a0da403801.png",1590,200,1}}},
  -- Normal-Large/snowy-mountains
  ["1135688223-1185-50"] = {pieces={{"1a0da1de22a.png",-1380,-1000,1},{"1a0da1a90be.png",-1380,200,1},{"1a0da1aa833.png",600,-1000,1},{"1a0da1e9db3.png",600,200,1}}},
  -- Normal-Large/eclipse
  ["1810660744-45087-40"] = {pieces={{"1a0da462373.png",-1380,-1000,1},{"1a0da3dd628.png",-1380,200,1},{"1a0da3e62cd.png",600,-1000,1},{"1a0da62ef98.png",600,200,1}}},
  -- Normal-Small/small-bat-2
  ["1737663745-52271-65"] = {pieces={{"1a0da4d88cc.png",-1380,-1000,1},{"1a0da4d2b0c.png",-1380,200,1},{"1a0da4ce4b5.png",400,-1000,1},{"1a0da4dcf24.png",400,200,1}}},
  -- Normal-Large/small-bat-2
  ["1868677844-55024-65"] = {pieces={{"1a0da1e3fee.png",-1380,-1000,1},{"1a0da1eb522.png",-1380,200,1},{"1a0da1f5946.png",600,-1000,1},{"1a0da1fb70b.png",600,200,1}}},
  -- Normal-Large/ice-collision
  ["1441136934-54034-19"] = {pieces={{"1a0da38a430.png",-1380,-1000,1},{"1a0da6250d0.png",-1380,200,1},{"1a0da62d826.png",-390,200,1},{"1a0da37736f.png",600,-1000,1},{"1a0da62c0b4.png",600,200,1},{"1a0da37e8a3.png",1590,200,1}}},
  -- Normal-Small/uranus-is-cold
  ["360829589-43147-39"] = {pieces={{"1a0da4cb5d3.png",-1380,-1000,1},{"1a0da4d59eb.png",-1380,200,1},{"1a0da4da048.png",400,-1000,1},{"1a0da4dfe04.png",400,200,1}}},
  -- Normal-Large/uranus-is-cold
  ["2047857447-48301-40"] = {pieces={{"1a0da18a47b.png",-1380,-1000,1},{"1a0da1846ba.png",-1380,200,1},{"1a0da17d18a.png",600,-1000,1},{"1a0da19600b.png",600,200,1}}},
  -- Normal-Small/lacostes
  ["1650000931-34229-58"] = {pieces={{"1a0da54956f.png",-1380,-1000,1},{"1a0da55221f.png",-1380,200,1},{"1a0da4f6109.png",400,-1000,1},{"1a0da55aec3.png",400,200,1}}},
  -- Normal-Large/lacostes
  ["960938660-38938-60"] = {pieces={{"1a0da36fe3f.png",-1380,-1000,1},{"1a0da30d451.png",-1380,200,1},{"1a0da31eda4.png",-390,200,1},{"1a0da31d63a.png",600,-1000,1},{"1a0da314982.png",600,200,1},{"1a0da327cd5.png",1590,200,1}}},
  -- Normal-Large/ice-booster
  ["297192898-38457-36"] = {pieces={{"1a0da398e8e.png",-1380,-1000,1},{"1a0da3930d0.png",-1380,200,1},{"1a0da39c068.png",-390,200,1},{"1a0da378adb.png",600,-1000,1},{"1a0da394841.png",600,200,1},{"1a0da395fa6.png",1590,200,1}}},
  -- Normal-Large/light-dark
  ["1376289201-41597-38"] = {pieces={{"1a0da30bcde.png",-1380,-1000,1},{"1a0da31321d.png",-1380,200,1},{"1a0da326561.png",600,-1000,1},{"1a0da36e6c6.png",600,200,1}}},
  -- Normal-Small/cyberpink-2
  ["243919337-61700-91"] = {pieces={{"1a0da576cf6.png",-1380,-1000,1},{"1a0da56df89.png",-1380,200,1},{"1a0da56f701.png",400,-1000,1},{"1a0da5a547d.png",400,200,1}}},
  -- Normal-Large/cyberpink-2
  ["629426588-48481-63"] = {pieces={{"1a0da46813a.png",-1380,-1000,1},{"1a0da3f35cd.png",-1380,200,1},{"1a0da404f77.png",600,-1000,1},{"1a0da3fc53b.png",600,200,1}}},
  -- Normal-Large/volley-2-0
  ["1186798916-64101-23"] = {pieces={{"1a0da18ead4.png",-1380,-1000,1},{"1a0da17ba0c.png",-1380,200,1},{"1a0da188d06.png",600,-1000,1},{"1a0da182f3e.png",600,200,1}}},
  -- Normal-Small/soccer
  ["1264399342-41470-61"] = {pieces={{"1a0da4e1576.png",-1380,-1000,1},{"1a0da4ccd46.png",-1380,200,1},{"1a0da4e2ce7.png",-490,200,1},{"1a0da4db7b0.png",400,-1000,1},{"1a0da4d715f.png",400,200,1},{"1a0da4d1395.png",1290,200,1}}},
  -- Normal-Large/soccer
  ["939945828-42800-61"] = {pieces={{"1a0da1efb7b.png",-1380,-1000,1},{"1a0da1f12ea.png",-1380,200,1},{"1a0da1e863b.png",-390,200,1},{"1a0da1a794a.png",600,-1000,1},{"1a0da1e287c.png",600,200,1},{"1a0da1dcab5.png",1590,200,1}}},
  -- Normal-Large/pink-date
  ["1244156286-2699-25"] = {pieces={{"1a0da2f8c29.png",-1380,-1000,1},{"1a0da30015c.png",-1380,200,1},{"1a0da320787.png",600,-1000,1},{"1a0da3047b1.png",600,200,1},{"1a0da329437.png",523,106,1,layer='!1000'}}},
  -- Normal-Large/kralizmox
  ["298514686-64647-23"] = {pieces={{"1a0da380017.png",-1380,-1000,1},{"1a0da385de1.png",-1380,200,1},{"1a0da37a245.png",600,-1000,1},{"1a0da374486.png",600,200,1},{"1a0da38ea7d.png",1590,200,1}}},
  -- Normal-Large/the-rainbow
  ["789572205-44067-61"] = {pieces={{"1a0da19a657.png",-1380,-1000,1},{"1a0da1a1e6a.png",-1380,200,1},{"1a0da1a340e.png",600,-1000,1},{"1a0da19eca9.png",600,200,1}}},
  -- Normal-Large/platforms
  ["795274638-50126-44"] = {pieces={{"1a0da2fbb0b.png",-1380,-1000,1},{"1a0da2f45d7.png",600,-1000,1}}},
  -- Normal-Large/some-chords
  ["1083064335-60707-21"] = {pieces={{"1a0da1e112c.png",-1380,-1000,1},{"1a0da619441.png",-1380,200,1},{"1a0da1db34d.png",600,-1000,1},{"1a0da1a61e8.png",600,200,1}}},
  -- Normal-Small/revamped-soccer
  ["1357855601-17542-54"] = {pieces={{"1a0da4ea221.png",-1380,-1000,1},{"1a0da4ed107.png",-1380,200,1},{"1a0da4e8aaf.png",400,-1000,1},{"1a0da4e5bcf.png",400,200,1}}},
  -- Normal-Large/revamped-soccer
  ["890188516-43622-40"] = {pieces={{"1a0da1ffd63.png",-1380,-1000,1},{"1a0da2014c9.png",-1380,200,1},{"1a0da205b21.png",-390,200,1},{"1a0da20a420.png",600,-1000,1},{"1a0da20b901.png",600,200,1},{"1a0da20ff3d.png",1590,200,1}}},
  -- Normal-Small/brazhell-soccer
  ["346073253-1976-48"] = {pieces={{"1a0da5b566b.png",-1380,-1000,1},{"1a0da5c40e2.png",-1380,200,1},{"1a0da5ab243.png",400,-1000,1},{"1a0da5a9ad2.png",400,200,1}}},
  -- Normal-Large/brazhell-soccer
  ["2129172144-3812-48"] = {pieces={{"1a0da470de8.png",-1380,-1000,1},{"1a0da48cb55.png",-1380,200,1},{"1a0da47f85a.png",600,-1000,1},{"1a0da47831c.png",600,200,1}}},
  -- Normal-Large/no-jump-tower
  ["221055177-44576-40"] = {pieces={{"1a0da31032f.png",-1380,-1000,1},{"1a0da311aa5.png",-1380,200,1},{"1a0da323764.png",-390,200,1},{"1a0da36b919.png",600,-1000,1},{"1a0da308dfb.png",600,200,1},{"1a0da36cf72.png",1590,200,1}}},
  -- Normal-Large/quad-cannons
  ["278744286-34291-39"] = {pieces={{"1a0da2f175c.png",-1380,-1000,1},{"1a0da2fa392.png",-1380,200,1},{"1a0da2f2e59.png",-390,200,1},{"1a0da2116af.png",600,-1000,1},{"1a0da2f5d3b.png",600,200,1},{"1a0da3018c9.png",1590,200,1}}},
  -- Normal-Small/frozen-soccer
  ["1363422216-40765-63"] = {pieces={{"1a0da54f336.png",-1380,-1000,1},{"1a0da547df9.png",-1380,200,1},{"1a0da4fbc94.png",-490,200,1},{"1a0da557fdf.png",400,-1000,1},{"1a0da560c91.png",400,200,1}}},
  -- Normal-Large/frozen-soccer
  ["1654785041-2624-51"] = {pieces={{"1a0da3d8fd3.png",-1380,-1000,1},{"1a0da3e33eb.png",-1380,200,1},{"1a0da3d1a93.png",-390,200,1},{"1a0da3e1c84.png",600,-1000,1},{"1a0da3a32a5.png",600,200,1},{"1a0da3ea924.png",1590,200,1}}},
  -- Normal-Small/der-lifter
  ["1313682024-52738-42"] = {pieces={{"1a0da59b21f.png",-1380,-1000,1},{"1a0da5652e4.png",-1380,200,1},{"1a0da5a25a0.png",400,-1000,1},{"1a0da574071.png",400,200,1}}},
  -- Normal-Large/der-lifter
  ["1411125234-53046-42"] = {pieces={{"1a0da45ae42.png",-1380,-1000,1},{"1a0da400922.png",-1380,200,1},{"1a0da3f7c20.png",600,-1000,1},{"1a0da3eef7b.png",600,200,1}}},
  -- Normal-Small/handball
  ["459691539-54015-67"] = {pieces={{"1a0da54dbc4.png",-1380,-1000,1},{"1a0da4fa528.png",-1380,200,1},{"1a0da54668d.png",400,-1000,1},{"1a0da55686c.png",400,200,1}}},
  -- Normal-Large/handball
  ["104315601-10118-74"] = {pieces={{"1a0da3d7861.png",-1380,-1000,1},{"1a0da3e91b4.png",-1380,200,1},{"1a0da3a1b71.png",600,-1000,1},{"1a0da3d0325.png",600,200,1}}},
  -- Normal-Large/portal-soccer
  ["1979431917-44886-64"] = {pieces={{"1a0da30303d.png",-1380,-1000,1},{"1a0da2fd26f.png",-1380,200,1},{"1a0da2fe9e8.png",600,-1000,1},{"1a0da2f74b5.png",600,200,1}}},
  -- Normal-Large/cannon-soccer
  ["421354534-29679-58"] = {pieces={{"1a0da485618.png",-1380,-1000,1},{"1a0da476bae.png",-1380,200,1},{"1a0da47e0e3.png",600,-1000,1},{"1a0da46f679.png",600,200,1}}},
  -- Normal-Large/eeerie-basement
  ["1468357515-56117-90"] = {pieces={{"1a0da3a4a1a.png",-1380,-1000,1},{"1a0da3ec09c.png",-1380,200,1},{"1a0da3d320c.png",600,-1000,1},{"1a0da3da743.png",600,200,1}}},
  -- Normal-Large/impostor
  ["1133007324-6310-26"] = {pieces={{"1a0da3901ee.png",-1380,-1000,1},{"1a0da375bf5.png",-1380,200,1},{"1a0da37d135.png",600,-1000,1},{"1a0da382efb.png",600,200,1}}},
  -- Normal-Large/ocean
  ["1808227127-59299-21"] = {pieces={{"1a0da305f1b.png",-1380,-1000,1},{"1a0da317870.png",-1380,200,1},{"1a0da30ebc7.png",-390,200,1},{"1a0da307687.png",600,-1000,1},{"1a0da318fd6.png",600,200,1},{"1a0da6221ec.png",1590,200,1}}},
  -- Normal-Small/squad
  ["1864146971-27340-59"] = {pieces={{"1a0cfa4c764.png",-1380,-1000,1},{"1a0cfa4dece.png",-1380,400,1},{"1a0cfa4f644.png",800,-1000,1},{"1a0cfa50dba.png",800,400,1}}},
  -- Normal-Large/squad
  ["132745405-29924-60"] = {pieces={{"1a0cfa52524.png",-1380,-1000,1},{"1a0cfa53c9e.png",110,-1000,1},{"1a0cfa5540e.png",1600,-1000,1},{"1a0cfa56b79.png",3090,-1000,1}}},
  -- Normal-Large/lava-bumpers
  ["1258496599-30784-37"] = {pieces={{"1a0d9afec95.png",-1380,-1000,1},{"1a0d9af8f46.png",-1380,200,1},{"1a0d9af022e.png",600,-1000,1},{"1a0d9bb25f4.png",600,200,1}}},
  -- Mode-3T-3-vivantes/default
  ["889308884-7140-26"] = {pieces={{"1a0da17e8f8.png",-1380,-1000,1},{"1a0da18bbf9.png",-1380,200,1},{"1a0da185e26.png",900,-1000,1},{"1a0da1919bb.png",900,200,1}}},
  -- Mode-3T-3-vivantes/ice-barrier
  ["842369232-9200-27"] = {pieces={{"1a0da0b9539.png",-1380,-1000,1},{"1a0da0b1f13.png",-1380,200,1},{"1a0da175c42.png",900,-1000,1},{"1a0da0b7ce0.png",900,200,1}}},
  -- Mode-3T-3-vivantes/sky-circles
  ["1808169034-18073-30"] = {pieces={{"1a0da0bdaa3.png",-1380,-1000,1},{"1a0da0a7afe.png",-1380,200,1},{"1a0da0a34a2.png",900,-1000,1},{"1a0da0af030.png",900,200,1}}},
  -- Mode-3T-3-vivantes/ice-collision
  ["293671015-59322-21"] = {pieces={{"1a0da0a926c.png",-1380,-1000,1},{"1a0da0aa9e3.png",-1380,200,1},{"1a0da0b07a9.png",-240,200,1},{"1a0da0b656f.png",900,-1000,1},{"1a0da0bf213.png",900,200,1},{"1a0da0a4c1c.png",2040,200,1}}},
  -- Mode-3T-3-vivantes/water-cannon
  ["1128677027-50880-44"] = {pieces={{"1a0da0bc336.png",-1380,-1000,1},{"1a0da0a1d33.png",-1380,200,1},{"1a0da0b4dfc.png",900,-1000,1}}},
  -- Normal-Extra-Large/default
  ["1137924375-926-24"] = {pieces={{"1a0da17e8f8.png",-1380,-1000,1},{"1a0da18bbf9.png",-1380,200,1},{"1a0da185e26.png",900,-1000,1},{"1a0da1919bb.png",900,200,1}}},
  -- Real/default
  ["2079965383-13046-28"] = {pieces={{"1a0cfa5e0b7.png",-1380,-1000,1},{"1a0cfa5f825.png",-1380,200,1},{"1a0cfa60f9a.png",-40,-1000,1},{"1a0cfa62706.png",1300,-1000,1},{"1a0cfa647d6.png",2640,-1000,1}}},
  -- Abyssal-Tide-backgrounds/four_two
  ["159660057-27943-57"] = {pieces={{"1a0dc9aa21d.png",-800,-760,1},{"1a0dc9ab99f.png",400,-760,1}}},
  -- Abyssal-Tide-backgrounds/three_reduced
  ["1133663579-30597-57"] = {pieces={{"1a0dc9a746f.png",-800,-741,1},{"1a0dc9a8abd.png",600,-741,1}}},
  -- Abyssal-Tide-backgrounds/normal_xl
  ["873333026-32773-57"] = {pieces={{"1a0dc9a157b.png",-800,-777,1},{"1a0dc9a2cf1.png",-800,123,1},{"1a0dc9a4467.png",900,-777,1},{"1a0dc9a5bd4.png",900,123,1}}},
  -- Abyssal-Tide-backgrounds/four
  ["965028882-27918-59"] = {pieces={{"1a0dc994358.png",-800,-771,1},{"1a0dc9959ec.png",800,-771,1},{"1a0dc997160.png",800,129,1}}},
  -- Abyssal-Tide-backgrounds/three
  ["1077929057-62970-47"] = {pieces={{"1a0dc9988d0.png",-800,-809,1},{"1a0dc99a03a.png",-800,91,1},{"1a0dc99b7b2.png",900,-809,1},{"1a0dc99cf26.png",900,91,1}}},
  -- Abyssal-Tide-backgrounds/four_three
  ["1341724065-61047-47"] = {pieces={{"1a0dc99e69c.png",-800,-738,1},{"1a0dc99fe15.png",600,-738,1}}},
  -- Black-Hole-backgrounds/four_two
  ["1910353760-63347-44"] = {pieces={{"1a0dc89e3bc.png",-800,-833,1},{"1a0dc89fb26.png",400,-833,1}}},
  -- Black-Hole-backgrounds/three_reduced
  ["199550533-21885-30"] = {pieces={{"1a0dc89b4df.png",-800,-729,1},{"1a0dc89cc57.png",600,-729,1}}},
  -- Black-Hole-backgrounds/normal_xl
  ["232960129-22122-30"] = {pieces={{"1a0dc895710.png",-800,-852,1},{"1a0dc896e7b.png",-800,48,1},{"1a0dc8985ed.png",900,-852,1},{"1a0dc899d61.png",900,48,1}}},
  -- Black-Hole-backgrounds/four
  ["387200682-46857-60"] = {pieces={{"1a0dc8886c0.png",-800,-811,1},{"1a0dc889b80.png",-800,89,1},{"1a0dc88b301.png",800,-811,1}}},
  -- Black-Hole-backgrounds/three
  ["813728279-1893-45"] = {pieces={{"1a0dc88ca69.png",-800,-781,1},{"1a0dc88e1d9.png",-800,119,1},{"1a0dc88f953.png",900,-781,1},{"1a0dc8910c0.png",900,119,1}}},
  -- Black-Hole-backgrounds/four_three
  ["1712816736-1392-45"] = {pieces={{"1a0dc89283d.png",-800,-840,1},{"1a0dc893fae.png",600,-840,1}}},
  -- Neon-Reactor-backgrounds/four_two
  ["462302972-59733-44"] = {pieces={{"1a0dc872acb.png",-800,-689,1},{"1a0dc874321.png",400,-689,1}}},
  -- Neon-Reactor-backgrounds/three_reduced
  ["390912037-62809-44"] = {pieces={{"1a0dc86fc85.png",-800,-675,1},{"1a0dc871381.png",600,-675,1}}},
  -- Neon-Reactor-backgrounds/normal_xl
  ["1702101070-65391-44"] = {pieces={{"1a0dc86ca2d.png",-800,-700,1},{"1a0dc86e194.png",900,-700,1}}},
  -- Neon-Reactor-backgrounds/four
  ["1346157954-39480-59"] = {pieces={{"1a0dc860ea1.png",-800,-708,1},{"1a0dc862608.png",800,-708,1}}},
  -- Neon-Reactor-backgrounds/three
  ["1795429764-5001-47"] = {pieces={{"1a0dc863d78.png",-800,-789,1},{"1a0dc8654dd.png",-800,111,1},{"1a0dc866c5d.png",900,-789,1},{"1a0dc8683d2.png",900,111,1}}},
  -- Neon-Reactor-backgrounds/four_three
  ["1951992032-4239-47"] = {pieces={{"1a0dc869b42.png",-800,-733,1},{"1a0dc86b2ae.png",600,-733,1}}},
  -- Sky-Temple-backgrounds/four_two
  ["1083277023-3767-47"] = {pieces={{"1a0dc853b32.png",-800,-762,1},{"1a0dc8552a3.png",-800,138,1},{"1a0dc856a23.png",400,-762,1}}},
  -- Sky-Temple-backgrounds/three_reduced
  ["987540983-6330-47"] = {pieces={{"1a0dc84dd70.png",-800,-767,1},{"1a0dc84f4e6.png",-800,133,1},{"1a0dc850c52.png",600,-767,1},{"1a0dc8523c7.png",600,133,1}}},
  -- Sky-Temple-backgrounds/normal_xl
  ["1229807852-10305-47"] = {pieces={{"1a0dc847fac.png",-800,-734,1},{"1a0dc849721.png",-800,166,1},{"1a0dc84ae8d.png",900,-734,1},{"1a0dc84c607.png",900,166,1}}},
  -- Sky-Temple-backgrounds/four
  ["395127669-30380-56"] = {pieces={{"1a0dc83694f.png",-800,-725,1},{"1a0dc837dd3.png",-800,175,1},{"1a0dc83953a.png",800,-725,1},{"1a0dc83acac.png",800,175,1}}},
  -- Sky-Temple-backgrounds/three
  ["196709261-64437-45"] = {pieces={{"1a0dc83c41d.png",-800,-743,1},{"1a0dc83db95.png",-800,157,1},{"1a0dc83f2f9.png",900,-743,1},{"1a0dc840a6e.png",900,157,1}}},
  -- Sky-Temple-backgrounds/four_three
  ["750588942-63816-45"] = {pieces={{"1a0dc8421e0.png",-800,-767,1},{"1a0dc843955.png",-800,133,1},{"1a0dc8450c0.png",600,-767,1},{"1a0dc846839.png",600,133,1}}},
}

catalog["2038814688-24792-31"] = catalog["232960129-22122-30"]

local published = {
  ["@7984981"] = catalog["1831244232-61344-74"],
  ["@7984757"] = catalog["232960129-22122-30"],
  ["@7984820"] = catalog["1016735131-64892-24"],
  ["@7985230"] = catalog["2122258609-4952-26"],
  ["@7984824"] = catalog["1487777147-1304-24"],
  ["@7984825"] = catalog["1477308136-1901-24"],
  ["@7984833"] = catalog["1091090761-8467-28"],
  ["@7984834"] = catalog["1031981444-9635-28"],
  ["@7984831"] = catalog["391272074-13488-28"],
  ["@7984832"] = catalog["1735625165-27850-33"],
  ["@7984841"] = catalog["1787514854-44520-42"],
  ["@7984842"] = catalog["359639136-45139-42"],
  ["@7984815"] = catalog["910414154-55942-20"],
  ["@7984816"] = catalog["1417298003-58668-21"],
  ["@7985234"] = catalog["1621442174-60348-22"],
  ["@7985235"] = catalog["1768448475-477-24"],
  ["@7984851"] = catalog["245039273-56023-20"],
  ["@7984852"] = catalog["1657347141-1170-24"],
  ["@7984853"] = catalog["795542110-53313-19"],
  ["@7984854"] = catalog["1301781552-53646-19"],
  ["@7984857"] = catalog["1887650777-65058-24"],
  ["@7984858"] = catalog["1102018813-63164-23"],
  ["@7984861"] = catalog["445253453-126-24"],
  ["@7984862"] = catalog["1713614305-629-24"],
  ["@7984865"] = catalog["591573356-9885-27"],
  ["@7984866"] = catalog["407195134-12743-28"],
  ["@7984868"] = catalog["1381927082-14116-29"],
  ["@7984869"] = catalog["27868905-14468-30"],
  ["@7984878"] = catalog["854156443-1368-24"],
  ["@7984881"] = catalog["642011180-58165-21"],
  ["@7984882"] = catalog["437068317-60893-22"],
  ["@7984885"] = catalog["1712287273-4398-52"],
  ["@7984886"] = catalog["1776885729-2174-51"],
  ["@7984887"] = catalog["1993190275-64997-24"],
  ["@7984888"] = catalog["401819792-6781-27"],
  ["@7985245"] = catalog["969611748-13931-29"],
  ["@7985246"] = catalog["122964921-14474-29"],
  ["@7984896"] = catalog["511231862-58082-21"],
  ["@7984897"] = catalog["86253651-60805-22"],
  ["@7984901"] = catalog["1852460807-2562-25"],
  ["@7984904"] = catalog["1224312110-23038-33"],
  ["@7984905"] = catalog["578030013-23555-33"],
  ["@7984908"] = catalog["958423611-58125-21"],
  ["@7984909"] = catalog["1860394395-60853-22"],
  ["@7984916"] = catalog["1453396622-15600-30"],
  ["@7984917"] = catalog["2004433308-15967-30"],
  ["@7984914"] = catalog["1758659694-5496-26"],
  ["@7984915"] = catalog["682168558-8300-27"],
  ["@7984918"] = catalog["1537626368-41603-40"],
  ["@7984919"] = catalog["1135688223-1185-50"],
  ["@7985263"] = catalog["875528437-44205-40"],
  ["@7985264"] = catalog["1810660744-45087-40"],
  ["@7984926"] = catalog["1737663745-52271-65"],
  ["@7984927"] = catalog["1868677844-55024-65"],
  ["@7984936"] = catalog["293671015-59322-21"],
  ["@7984932"] = catalog["1822746474-53285-19"],
  ["@7984933"] = catalog["1441136934-54034-19"],
  ["@7984937"] = catalog["360829589-43147-39"],
  ["@7984938"] = catalog["2047857447-48301-40"],
  ["@7984939"] = catalog["1650000931-34229-58"],
  ["@7984940"] = catalog["960938660-38938-60"],
  ["@7984942"] = catalog["48666429-20590-30"],
  ["@7984943"] = catalog["297192898-38457-36"],
  ["@7984946"] = catalog["628568408-39818-37"],
  ["@7984947"] = catalog["1376289201-41597-38"],
  ["@7984950"] = catalog["243919337-61700-91"],
  ["@7984951"] = catalog["629426588-48481-63"],
  ["@7984953"] = catalog["1894748033-61372-22"],
  ["@7984954"] = catalog["1186798916-64101-23"],
  ["@7984957"] = catalog["1264399342-41470-61"],
  ["@7984958"] = catalog["939945828-42800-61"],
  ["@7984970"] = catalog["1589179725-5173-26"],
  ["@7984971"] = catalog["1244156286-2699-25"],
  ["@7985259"] = catalog["961490928-61509-22"],
  ["@7985260"] = catalog["298514686-64647-23"],
  ["@7984974"] = catalog["674080404-61395-45"],
  ["@7984976"] = catalog["789572205-44067-61"],
  ["@7984979"] = catalog["1960478565-49471-44"],
  ["@7984980"] = catalog["795274638-50126-44"],
  ["@7984983"] = catalog["1997224107-59875-21"],
  ["@7984984"] = catalog["1083064335-60707-21"],
  ["@7984987"] = catalog["1357855601-17542-54"],
  ["@7984988"] = catalog["890188516-43622-40"],
  ["@7984993"] = catalog["346073253-1976-48"],
  ["@7984994"] = catalog["2129172144-3812-48"],
  ["@7984996"] = catalog["221055177-44576-40"],
  ["@7985005"] = catalog["1418215341-33635-39"],
  ["@7985006"] = catalog["278744286-34291-39"],
  ["@7985239"] = catalog["1363422216-40765-63"],
  ["@7985240"] = catalog["1654785041-2624-51"],
  ["@7985013"] = catalog["1313682024-52738-42"],
  ["@7985014"] = catalog["1411125234-53046-42"],
  ["@7985015"] = catalog["459691539-54015-67"],
  ["@7985016"] = catalog["104315601-10118-74"],
  ["@7985018"] = catalog["1979431917-44886-64"],
  ["@7985020"] = catalog["421354534-29679-58"],
  ["@7985022"] = catalog["1468357515-56117-90"],
  ["@7985023"] = catalog["1704795425-5839-26"],
  ["@7985024"] = catalog["1133007324-6310-26"],
  ["@7985034"] = catalog["1096865655-58884-21"],
  ["@7985035"] = catalog["1808227127-59299-21"],
  ["@7984844"] = catalog["1128677027-50880-44"],
  ["@7984843"] = catalog["511300641-6322-52"],
  ["@7984845"] = catalog["1317108441-58308-47"],
  ["@7985237"] = catalog["842369232-9200-27"],
  ["@7985236"] = catalog["1255615608-31934-36"],
  ["@7985238"] = catalog["33464961-16018-30"],
  ["@7984827"] = catalog["1808169034-18073-30"],
  ["@7985219"] = catalog["2104810837-42608-39"],
  ["@7985220"] = catalog["718434695-26197-33"],
  ["@7984870"] = catalog["989426023-86-50"],
  ["@7984871"] = catalog["888612367-42418-41"],
  ["@7984902"] = catalog["1241378045-39248-39"],
  ["@7984903"] = catalog["1863983187-20962-32"],
  ["@7984883"] = catalog["29804111-31793-36"],
  ["@7984884"] = catalog["1379230538-16022-30"],
  ["@7984863"] = catalog["1601554952-40537-39"],
  ["@7984864"] = catalog["266979220-29267-35"],
  ["@7985233"] = catalog["983469419-23770-34"],
  ["@7984889"] = catalog["1963181140-43286-41"],
  ["@7984890"] = catalog["1945054654-25171-34"],
  ["@7985209"] = catalog["581305930-42398-40"],
  ["@7985210"] = catalog["794736983-24134-33"],
  ["@7985211"] = catalog["340925034-5743-26"],
  ["@7984879"] = catalog["1059313160-43904-40"],
  ["@7984880"] = catalog["3028665-24963-33"],
  ["@7985247"] = catalog["1499850571-53211-44"],
  ["@7985248"] = catalog["1086810883-32255-36"],
  ["@7984898"] = catalog["1846317034-31705-36"],
  ["@7984899"] = catalog["2131679833-16288-30"],
  ["@7985227"] = catalog["691402623-63900-47"],
  ["@7985228"] = catalog["1458537000-50256-42"],
  ["@7985229"] = catalog["996910509-36323-37"],
  ["@7984911"] = catalog["1122741249-15945-30"],
  ["@7984855"] = catalog["871101487-11952-28"],
  ["@7984856"] = catalog["1189449156-3744-25"],
  ["@7984907"] = catalog["1023816945-42085-40"],
  ["@7984859"] = catalog["1347981057-24025-33"],
  ["@7984860"] = catalog["1016435664-7889-27"],
  ["@7984920"] = catalog["119963061-30534-61"],
  ["@7984921"] = catalog["903368474-7303-52"],
  ["@7985206"] = catalog["1350155980-24112-33"],
  ["@7985207"] = catalog["1300850221-13470-29"],
  ["@7985208"] = catalog["1840287158-64752-24"],
  ["@7985221"] = catalog["1903731991-9313-27"],
  ["@7985222"] = catalog["121079253-64048-23"],
  ["@7985223"] = catalog["825754486-53026-19"],
  ["@7985265"] = catalog["185798889-27811-58"],
  ["@7985266"] = catalog["746451074-63130-47"],
  ["@7985224"] = catalog["981421898-508-50"],
  ["@7985225"] = catalog["99676748-33139-37"],
  ["@7985226"] = catalog["1353436214-9908-28"],
  ["@7984934"] = catalog["66564796-6556-26"],
  ["@7984935"] = catalog["703387704-61332-22"],
  ["@7984944"] = catalog["265867957-54335-42"],
  ["@7984945"] = catalog["943467518-34411-35"],
  ["@7984949"] = catalog["1363039590-65305-46"],
  ["@7984955"] = catalog["1531039119-33629-36"],
  ["@7984956"] = catalog["1610133592-12440-28"],
  ["@7984972"] = catalog["1826231665-52288-44"],
  ["@7984973"] = catalog["461852483-28897-35"],
  ["@7985261"] = catalog["1935028562-15846-29"],
  ["@7985262"] = catalog["1550811378-4572-25"],
  ["@7984977"] = catalog["45162040-19306-77"],
  ["@7984978"] = catalog["77715627-38410-60"],
  ["@7984982"] = catalog["1912369198-19949-58"],
  ["@7984985"] = catalog["1910961868-17324-29"],
  ["@7985008"] = catalog["1289164141-42145-42"],
  ["@7984818"] = catalog["889308884-7140-26"],
  ["@7985199"] = catalog["919598699-28963-34"],
  ["@7985200"] = catalog["833579328-15288-29"],
  ["@7985025"] = catalog["1072698299-41822-40"],
  ["@7985026"] = catalog["1638070039-21137-32"],
  ["@7985036"] = catalog["1527176577-11680-28"],
  ["@7985037"] = catalog["1077430992-681-24"],
  ["@7985076"] = catalog["1587188712-8732-48"],
  ["@7985077"] = catalog["2017524639-41915-38"],
  ["@7985078"] = catalog["1251134541-30818-34"],
  ["@7985068"] = catalog["41367870-34427-57"],
  ["@7985069"] = catalog["420110573-34559-56"],
  ["@7985079"] = catalog["1173766353-12112-50"],
  ["@7985080"] = catalog["140145077-57552-43"],
  ["@7985081"] = catalog["600319957-37260-36"],
  ["@7984986"] = catalog["1375202986-5802-25"],
  ["@7985066"] = catalog["1148044508-23278-56"],
  ["@7985038"] = catalog["1864146971-27340-59"],
  ["@7985039"] = catalog["132745405-29924-60"],
  ["@7985203"] = catalog["1561675655-39058-38"],
  ["@7985204"] = catalog["963275648-11394-28"],
  ["@7985205"] = catalog["354914538-62695-23"],
  ["@7985196"] = catalog["1290976541-39740-39"],
  ["@7985277"] = catalog["313291704-5628-26"],
  ["@7985198"] = catalog["1818935705-57608-21"],
  ["@7985094"] = catalog["1988855872-39799-60"],
  ["@7985095"] = catalog["240200155-30989-57"],
  ["@7985096"] = catalog["1680660502-41790-38"],
  ["@7985097"] = catalog["1288090053-6033-52"],
  ["@7985098"] = catalog["1319047903-40208-40"],
  ["@7985099"] = catalog["1610576830-17161-31"],
  ["@7985216"] = catalog["1830686295-54297-43"],
  ["@7985217"] = catalog["906250125-29265-34"],
  ["@7985218"] = catalog["136691248-7037-26"],
  ["@7985214"] = catalog["1339350618-13674-56"],
  ["@7985215"] = catalog["871847179-59673-48"],
  ["@7985212"] = catalog["1189579043-23182-34"],
  ["@7985213"] = catalog["1258496599-30784-37"],
  ["@7984775"] = catalog["1083277023-3767-47"],
  ["@7984776"] = catalog["987540983-6330-47"],
  ["@7984639"] = catalog["1229807852-10305-47"],
  ["@7984777"] = catalog["395127669-30380-56"],
  ["@7984778"] = catalog["196709261-64437-45"],
  ["@7984779"] = catalog["750588942-63816-45"],
  ["@7984782"] = catalog["1346157954-39480-59"],
  ["@7984783"] = catalog["1795429764-5001-47"],
  ["@7984781"] = catalog["390912037-62809-44"],
  ["@7984784"] = catalog["1951992032-4239-47"],
  ["@7984780"] = catalog["462302972-59733-44"],
  ["@7984661"] = catalog["1702101070-65391-44"],
  ["@7985111"] = catalog["1910353760-63347-44"],
  ["@7985112"] = catalog["199550533-21885-30"],
  ["@7985113"] = catalog["387200682-46857-60"],
  ["@7985114"] = catalog["813728279-1893-45"],
  ["@7985115"] = catalog["1712816736-1392-45"],
  ["@7984785"] = catalog["159660057-27943-57"],
  ["@7984786"] = catalog["1133663579-30597-57"],
  ["@7984787"] = catalog["965028882-27918-59"],
  ["@7984788"] = catalog["1077929057-62970-47"],
  ["@7984789"] = catalog["1341724065-61047-47"],
}
catalog["511300641-6322-52"].width = 1600
catalog["511300641-6322-52"].height = 400
catalog["1317108441-58308-47"].width = 1200
catalog["1317108441-58308-47"].height = 400
catalog["1787514854-44520-42"].width = 800
catalog["1787514854-44520-42"].height = 400
catalog["1255615608-31934-36"].width = 1600
catalog["1255615608-31934-36"].height = 400
catalog["33464961-16018-30"].width = 1200
catalog["33464961-16018-30"].height = 400
catalog["1621442174-60348-22"].width = 800
catalog["1621442174-60348-22"].height = 400
catalog["2104810837-42608-39"].width = 1600
catalog["2104810837-42608-39"].height = 400
catalog["718434695-26197-33"].width = 1200
catalog["718434695-26197-33"].height = 400
catalog["1487777147-1304-24"].width = 800
catalog["1487777147-1304-24"].height = 400
catalog["989426023-86-50"].width = 1600
catalog["989426023-86-50"].height = 400
catalog["888612367-42418-41"].width = 1200
catalog["888612367-42418-41"].height = 400
catalog["1381927082-14116-29"].width = 800
catalog["1381927082-14116-29"].height = 400
catalog["1241378045-39248-39"].width = 1600
catalog["1241378045-39248-39"].height = 400
catalog["1863983187-20962-32"].width = 1200
catalog["1863983187-20962-32"].height = 400
catalog["29804111-31793-36"].width = 1600
catalog["29804111-31793-36"].height = 400
catalog["1379230538-16022-30"].width = 1200
catalog["1379230538-16022-30"].height = 400
catalog["642011180-58165-21"].width = 800
catalog["642011180-58165-21"].height = 400
catalog["1601554952-40537-39"].width = 1600
catalog["1601554952-40537-39"].height = 400
catalog["266979220-29267-35"].width = 1200
catalog["266979220-29267-35"].height = 400
catalog["445253453-126-24"].width = 800
catalog["445253453-126-24"].height = 400
catalog["983469419-23770-34"].width = 1200
catalog["983469419-23770-34"].height = 400
catalog["1016735131-64892-24"].width = 800
catalog["1016735131-64892-24"].height = 400
catalog["1963181140-43286-41"].width = 1600
catalog["1963181140-43286-41"].height = 400
catalog["1945054654-25171-34"].width = 1200
catalog["1945054654-25171-34"].height = 400
catalog["1993190275-64997-24"].width = 800
catalog["1993190275-64997-24"].height = 400
catalog["581305930-42398-40"].width = 1600
catalog["581305930-42398-40"].height = 400
catalog["794736983-24134-33"].width = 1200
catalog["794736983-24134-33"].height = 400
catalog["340925034-5743-26"].width = 800
catalog["340925034-5743-26"].height = 400
catalog["1059313160-43904-40"].width = 1600
catalog["1059313160-43904-40"].height = 400
catalog["3028665-24963-33"].width = 1200
catalog["3028665-24963-33"].height = 400
catalog["1499850571-53211-44"].width = 1600
catalog["1499850571-53211-44"].height = 400
catalog["1086810883-32255-36"].width = 1200
catalog["1086810883-32255-36"].height = 400
catalog["969611748-13931-29"].width = 800
catalog["969611748-13931-29"].height = 400
catalog["1846317034-31705-36"].width = 1600
catalog["1846317034-31705-36"].height = 400
catalog["2131679833-16288-30"].width = 1200
catalog["2131679833-16288-30"].height = 400
catalog["511231862-58082-21"].width = 800
catalog["511231862-58082-21"].height = 400
catalog["691402623-63900-47"].width = 1600
catalog["691402623-63900-47"].height = 400
catalog["1458537000-50256-42"].width = 1200
catalog["1458537000-50256-42"].height = 400
catalog["996910509-36323-37"].width = 800
catalog["996910509-36323-37"].height = 400
catalog["1122741249-15945-30"].width = 1200
catalog["1122741249-15945-30"].height = 400
catalog["958423611-58125-21"].width = 800
catalog["958423611-58125-21"].height = 400
catalog["871101487-11952-28"].width = 1600
catalog["871101487-11952-28"].height = 400
catalog["1189449156-3744-25"].width = 1200
catalog["1189449156-3744-25"].height = 400
catalog["795542110-53313-19"].width = 800
catalog["795542110-53313-19"].height = 400
catalog["1023816945-42085-40"].width = 1200
catalog["1023816945-42085-40"].height = 400
catalog["1224312110-23038-33"].width = 800
catalog["1224312110-23038-33"].height = 400
catalog["1347981057-24025-33"].width = 1600
catalog["1347981057-24025-33"].height = 400
catalog["1016435664-7889-27"].width = 1200
catalog["1016435664-7889-27"].height = 400
catalog["1887650777-65058-24"].width = 800
catalog["1887650777-65058-24"].height = 400
catalog["119963061-30534-61"].width = 1600
catalog["119963061-30534-61"].height = 400
catalog["903368474-7303-52"].width = 1200
catalog["903368474-7303-52"].height = 400
catalog["1537626368-41603-40"].width = 800
catalog["1537626368-41603-40"].height = 400
catalog["1350155980-24112-33"].width = 1600
catalog["1350155980-24112-33"].height = 400
catalog["1300850221-13470-29"].width = 1200
catalog["1300850221-13470-29"].height = 400
catalog["1840287158-64752-24"].width = 800
catalog["1840287158-64752-24"].height = 400
catalog["1903731991-9313-27"].width = 1600
catalog["1903731991-9313-27"].height = 400
catalog["121079253-64048-23"].width = 1200
catalog["121079253-64048-23"].height = 400
catalog["825754486-53026-19"].width = 800
catalog["825754486-53026-19"].height = 400
catalog["185798889-27811-58"].width = 1600
catalog["185798889-27811-58"].height = 400
catalog["746451074-63130-47"].width = 1200
catalog["746451074-63130-47"].height = 400
catalog["875528437-44205-40"].width = 800
catalog["875528437-44205-40"].height = 400
catalog["981421898-508-50"].width = 1600
catalog["981421898-508-50"].height = 400
catalog["99676748-33139-37"].width = 1200
catalog["99676748-33139-37"].height = 400
catalog["1353436214-9908-28"].width = 800
catalog["1353436214-9908-28"].height = 400
catalog["66564796-6556-26"].width = 1600
catalog["66564796-6556-26"].height = 400
catalog["703387704-61332-22"].width = 1200
catalog["703387704-61332-22"].height = 400
catalog["1822746474-53285-19"].width = 800
catalog["1822746474-53285-19"].height = 400
catalog["265867957-54335-42"].width = 1600
catalog["265867957-54335-42"].height = 400
catalog["943467518-34411-35"].width = 1200
catalog["943467518-34411-35"].height = 400
catalog["48666429-20590-30"].width = 800
catalog["48666429-20590-30"].height = 400
catalog["1363039590-65305-46"].width = 1200
catalog["1363039590-65305-46"].height = 400
catalog["628568408-39818-37"].width = 800
catalog["628568408-39818-37"].height = 400
catalog["1531039119-33629-36"].width = 1600
catalog["1531039119-33629-36"].height = 400
catalog["1610133592-12440-28"].width = 1200
catalog["1610133592-12440-28"].height = 400
catalog["1894748033-61372-22"].width = 800
catalog["1894748033-61372-22"].height = 400
catalog["1826231665-52288-44"].width = 1600
catalog["1826231665-52288-44"].height = 400
catalog["461852483-28897-35"].width = 1200
catalog["461852483-28897-35"].height = 400
catalog["1589179725-5173-26"].width = 800
catalog["1589179725-5173-26"].height = 400
catalog["1935028562-15846-29"].width = 1600
catalog["1935028562-15846-29"].height = 400
catalog["1550811378-4572-25"].width = 1200
catalog["1550811378-4572-25"].height = 400
catalog["961490928-61509-22"].width = 800
catalog["961490928-61509-22"].height = 400
catalog["45162040-19306-77"].width = 1600
catalog["45162040-19306-77"].height = 400
catalog["77715627-38410-60"].width = 1200
catalog["77715627-38410-60"].height = 400
catalog["674080404-61395-45"].width = 800
catalog["674080404-61395-45"].height = 400
catalog["1831244232-61344-74"].width = 1600
catalog["1831244232-61344-74"].height = 400
catalog["1912369198-19949-58"].width = 1200
catalog["1912369198-19949-58"].height = 400
catalog["1960478565-49471-44"].width = 800
catalog["1960478565-49471-44"].height = 400
catalog["1910961868-17324-29"].width = 1600
catalog["1910961868-17324-29"].height = 400
catalog["1375202986-5802-25"].width = 1200
catalog["1375202986-5802-25"].height = 400
catalog["1997224107-59875-21"].width = 800
catalog["1997224107-59875-21"].height = 400
catalog["1289164141-42145-42"].width = 1200
catalog["1289164141-42145-42"].height = 400
catalog["1418215341-33635-39"].width = 800
catalog["1418215341-33635-39"].height = 400
catalog["919598699-28963-34"].width = 1600
catalog["919598699-28963-34"].height = 400
catalog["833579328-15288-29"].width = 1200
catalog["833579328-15288-29"].height = 400
catalog["910414154-55942-20"].width = 800
catalog["910414154-55942-20"].height = 400
catalog["1072698299-41822-40"].width = 1600
catalog["1072698299-41822-40"].height = 400
catalog["1638070039-21137-32"].width = 1200
catalog["1638070039-21137-32"].height = 400
catalog["1704795425-5839-26"].width = 800
catalog["1704795425-5839-26"].height = 400
catalog["1527176577-11680-28"].width = 1600
catalog["1527176577-11680-28"].height = 400
catalog["1077430992-681-24"].width = 1200
catalog["1077430992-681-24"].height = 400
catalog["1096865655-58884-21"].width = 800
catalog["1096865655-58884-21"].height = 400
catalog["1587188712-8732-48"].width = 1600
catalog["1587188712-8732-48"].height = 400
catalog["2017524639-41915-38"].width = 1200
catalog["2017524639-41915-38"].height = 400
catalog["1251134541-30818-34"].width = 800
catalog["1251134541-30818-34"].height = 400
catalog["1148044508-23278-56"].width = 1600
catalog["1148044508-23278-56"].height = 400
catalog["41367870-34427-57"].width = 1200
catalog["41367870-34427-57"].height = 400
catalog["420110573-34559-56"].width = 800
catalog["420110573-34559-56"].height = 400
catalog["1173766353-12112-50"].width = 1600
catalog["1173766353-12112-50"].height = 400
catalog["140145077-57552-43"].width = 1200
catalog["140145077-57552-43"].height = 400
catalog["600319957-37260-36"].width = 800
catalog["600319957-37260-36"].height = 400
catalog["1561675655-39058-38"].width = 1600
catalog["1561675655-39058-38"].height = 400
catalog["963275648-11394-28"].width = 1200
catalog["963275648-11394-28"].height = 400
catalog["354914538-62695-23"].width = 800
catalog["354914538-62695-23"].height = 400
catalog["1290976541-39740-39"].width = 1600
catalog["1290976541-39740-39"].height = 400
catalog["313291704-5628-26"].width = 1200
catalog["313291704-5628-26"].height = 400
catalog["1818935705-57608-21"].width = 800
catalog["1818935705-57608-21"].height = 400
catalog["1988855872-39799-60"].width = 1600
catalog["1988855872-39799-60"].height = 400
catalog["240200155-30989-57"].width = 1200
catalog["240200155-30989-57"].height = 400
catalog["1680660502-41790-38"].width = 800
catalog["1680660502-41790-38"].height = 400
catalog["1288090053-6033-52"].width = 1600
catalog["1288090053-6033-52"].height = 400
catalog["1319047903-40208-40"].width = 1200
catalog["1319047903-40208-40"].height = 400
catalog["1610576830-17161-31"].width = 800
catalog["1610576830-17161-31"].height = 400
catalog["1830686295-54297-43"].width = 1600
catalog["1830686295-54297-43"].height = 400
catalog["906250125-29265-34"].width = 1200
catalog["906250125-29265-34"].height = 400
catalog["136691248-7037-26"].width = 800
catalog["136691248-7037-26"].height = 400
catalog["1339350618-13674-56"].width = 1600
catalog["1339350618-13674-56"].height = 400
catalog["871847179-59673-48"].width = 1200
catalog["871847179-59673-48"].height = 400
catalog["1189579043-23182-34"].width = 800
catalog["1189579043-23182-34"].height = 400
catalog["2122258609-4952-26"].width = 1200
catalog["2122258609-4952-26"].height = 400
catalog["1477308136-1901-24"].width = 1200
catalog["1477308136-1901-24"].height = 400
catalog["1091090761-8467-28"].width = 800
catalog["1091090761-8467-28"].height = 400
catalog["1031981444-9635-28"].width = 1200
catalog["1031981444-9635-28"].height = 400
catalog["391272074-13488-28"].width = 800
catalog["391272074-13488-28"].height = 400
catalog["1735625165-27850-33"].width = 1200
catalog["1735625165-27850-33"].height = 400
catalog["359639136-45139-42"].width = 1200
catalog["359639136-45139-42"].height = 400
catalog["1417298003-58668-21"].width = 1200
catalog["1417298003-58668-21"].height = 400
catalog["1768448475-477-24"].width = 1200
catalog["1768448475-477-24"].height = 400
catalog["245039273-56023-20"].width = 800
catalog["245039273-56023-20"].height = 400
catalog["1657347141-1170-24"].width = 1200
catalog["1657347141-1170-24"].height = 400
catalog["1301781552-53646-19"].width = 1200
catalog["1301781552-53646-19"].height = 400
catalog["1102018813-63164-23"].width = 1200
catalog["1102018813-63164-23"].height = 400
catalog["1713614305-629-24"].width = 1200
catalog["1713614305-629-24"].height = 400
catalog["591573356-9885-27"].width = 800
catalog["591573356-9885-27"].height = 400
catalog["407195134-12743-28"].width = 1200
catalog["407195134-12743-28"].height = 400
catalog["27868905-14468-30"].width = 1200
catalog["27868905-14468-30"].height = 400
catalog["854156443-1368-24"].width = 1200
catalog["854156443-1368-24"].height = 400
catalog["437068317-60893-22"].width = 1200
catalog["437068317-60893-22"].height = 400
catalog["1712287273-4398-52"].width = 800
catalog["1712287273-4398-52"].height = 400
catalog["1776885729-2174-51"].width = 1200
catalog["1776885729-2174-51"].height = 400
catalog["401819792-6781-27"].width = 1200
catalog["401819792-6781-27"].height = 400
catalog["122964921-14474-29"].width = 1200
catalog["122964921-14474-29"].height = 400
catalog["86253651-60805-22"].width = 1200
catalog["86253651-60805-22"].height = 400
catalog["1852460807-2562-25"].width = 1200
catalog["1852460807-2562-25"].height = 400
catalog["578030013-23555-33"].width = 1200
catalog["578030013-23555-33"].height = 400
catalog["1860394395-60853-22"].width = 1200
catalog["1860394395-60853-22"].height = 400
catalog["1453396622-15600-30"].width = 800
catalog["1453396622-15600-30"].height = 400
catalog["2004433308-15967-30"].width = 1200
catalog["2004433308-15967-30"].height = 400
catalog["1758659694-5496-26"].width = 800
catalog["1758659694-5496-26"].height = 400
catalog["682168558-8300-27"].width = 1200
catalog["682168558-8300-27"].height = 400
catalog["1135688223-1185-50"].width = 1200
catalog["1135688223-1185-50"].height = 400
catalog["1810660744-45087-40"].width = 1200
catalog["1810660744-45087-40"].height = 400
catalog["1737663745-52271-65"].width = 800
catalog["1737663745-52271-65"].height = 400
catalog["1868677844-55024-65"].width = 1200
catalog["1868677844-55024-65"].height = 400
catalog["1441136934-54034-19"].width = 1200
catalog["1441136934-54034-19"].height = 400
catalog["360829589-43147-39"].width = 800
catalog["360829589-43147-39"].height = 400
catalog["2047857447-48301-40"].width = 1200
catalog["2047857447-48301-40"].height = 400
catalog["1650000931-34229-58"].width = 800
catalog["1650000931-34229-58"].height = 400
catalog["960938660-38938-60"].width = 1200
catalog["960938660-38938-60"].height = 400
catalog["297192898-38457-36"].width = 1200
catalog["297192898-38457-36"].height = 400
catalog["1376289201-41597-38"].width = 1200
catalog["1376289201-41597-38"].height = 400
catalog["243919337-61700-91"].width = 800
catalog["243919337-61700-91"].height = 400
catalog["629426588-48481-63"].width = 1200
catalog["629426588-48481-63"].height = 400
catalog["1186798916-64101-23"].width = 1200
catalog["1186798916-64101-23"].height = 400
catalog["1264399342-41470-61"].width = 800
catalog["1264399342-41470-61"].height = 400
catalog["939945828-42800-61"].width = 1200
catalog["939945828-42800-61"].height = 400
catalog["1244156286-2699-25"].width = 1200
catalog["1244156286-2699-25"].height = 400
catalog["298514686-64647-23"].width = 1200
catalog["298514686-64647-23"].height = 400
catalog["789572205-44067-61"].width = 1200
catalog["789572205-44067-61"].height = 400
catalog["795274638-50126-44"].width = 1200
catalog["795274638-50126-44"].height = 400
catalog["1083064335-60707-21"].width = 1200
catalog["1083064335-60707-21"].height = 400
catalog["1357855601-17542-54"].width = 800
catalog["1357855601-17542-54"].height = 400
catalog["890188516-43622-40"].width = 1200
catalog["890188516-43622-40"].height = 400
catalog["346073253-1976-48"].width = 800
catalog["346073253-1976-48"].height = 400
catalog["2129172144-3812-48"].width = 1200
catalog["2129172144-3812-48"].height = 400
catalog["221055177-44576-40"].width = 1200
catalog["221055177-44576-40"].height = 400
catalog["278744286-34291-39"].width = 1200
catalog["278744286-34291-39"].height = 400
catalog["1363422216-40765-63"].width = 800
catalog["1363422216-40765-63"].height = 400
catalog["1654785041-2624-51"].width = 1200
catalog["1654785041-2624-51"].height = 400
catalog["1313682024-52738-42"].width = 800
catalog["1313682024-52738-42"].height = 400
catalog["1411125234-53046-42"].width = 1200
catalog["1411125234-53046-42"].height = 400
catalog["459691539-54015-67"].width = 800
catalog["459691539-54015-67"].height = 400
catalog["104315601-10118-74"].width = 1200
catalog["104315601-10118-74"].height = 400
catalog["1979431917-44886-64"].width = 1200
catalog["1979431917-44886-64"].height = 400
catalog["421354534-29679-58"].width = 1200
catalog["421354534-29679-58"].height = 400
catalog["1468357515-56117-90"].width = 1200
catalog["1468357515-56117-90"].height = 400
catalog["1133007324-6310-26"].width = 1200
catalog["1133007324-6310-26"].height = 400
catalog["1808227127-59299-21"].width = 1200
catalog["1808227127-59299-21"].height = 400
catalog["1864146971-27340-59"].width = 1600
catalog["1864146971-27340-59"].height = 800
catalog["132745405-29924-60"].width = 3200
catalog["132745405-29924-60"].height = 800
catalog["1258496599-30784-37"].width = 1200
catalog["1258496599-30784-37"].height = 400
catalog["889308884-7140-26"].width = 1800
catalog["889308884-7140-26"].height = 400
catalog["842369232-9200-27"].width = 1800
catalog["842369232-9200-27"].height = 400
catalog["1808169034-18073-30"].width = 1800
catalog["1808169034-18073-30"].height = 400
catalog["293671015-59322-21"].width = 1800
catalog["293671015-59322-21"].height = 400
catalog["1128677027-50880-44"].width = 1800
catalog["1128677027-50880-44"].height = 400
catalog["1137924375-926-24"].width = 1800
catalog["1137924375-926-24"].height = 400
catalog["2079965383-13046-28"].width = 2600
catalog["2079965383-13046-28"].height = 400
catalog["159660057-27943-57"].width = 800
catalog["159660057-27943-57"].height = 400
catalog["1133663579-30597-57"].width = 1200
catalog["1133663579-30597-57"].height = 400
catalog["873333026-32773-57"].width = 1800
catalog["873333026-32773-57"].height = 400
catalog["965028882-27918-59"].width = 1600
catalog["965028882-27918-59"].height = 400
catalog["1077929057-62970-47"].width = 1800
catalog["1077929057-62970-47"].height = 400
catalog["1341724065-61047-47"].width = 1200
catalog["1341724065-61047-47"].height = 400
catalog["1910353760-63347-44"].width = 800
catalog["1910353760-63347-44"].height = 400
catalog["199550533-21885-30"].width = 1200
catalog["199550533-21885-30"].height = 400
catalog["232960129-22122-30"].width = 1800
catalog["232960129-22122-30"].height = 400
catalog["387200682-46857-60"].width = 1600
catalog["387200682-46857-60"].height = 400
catalog["813728279-1893-45"].width = 1800
catalog["813728279-1893-45"].height = 400
catalog["1712816736-1392-45"].width = 1200
catalog["1712816736-1392-45"].height = 400
catalog["462302972-59733-44"].width = 800
catalog["462302972-59733-44"].height = 400
catalog["390912037-62809-44"].width = 1200
catalog["390912037-62809-44"].height = 400
catalog["1702101070-65391-44"].width = 1800
catalog["1702101070-65391-44"].height = 400
catalog["1346157954-39480-59"].width = 1600
catalog["1346157954-39480-59"].height = 400
catalog["1795429764-5001-47"].width = 1800
catalog["1795429764-5001-47"].height = 400
catalog["1951992032-4239-47"].width = 1200
catalog["1951992032-4239-47"].height = 400
catalog["1083277023-3767-47"].width = 800
catalog["1083277023-3767-47"].height = 400
catalog["987540983-6330-47"].width = 1200
catalog["987540983-6330-47"].height = 400
catalog["1229807852-10305-47"].width = 1800
catalog["1229807852-10305-47"].height = 400
catalog["395127669-30380-56"].width = 1600
catalog["395127669-30380-56"].height = 400
catalog["196709261-64437-45"].width = 1800
catalog["196709261-64437-45"].height = 400
catalog["750588942-63816-45"].width = 1200
catalog["750588942-63816-45"].height = 400

published["@7985272"] = published["@7984979"]
published["@7985273"] = published["@7984980"]
published["@7985274"] = published["@7984981"]
published["@7985275"] = published["@7984982"]
published["@7985278"] = published["@7984981"]
-- Background uploads verified pixel-for-pixel, 2026-10-01.
catalog["2074728831-42326-38"] = {["pieces"]={[1]={[1]="1a0f82938e5.png",[2]=-800,[3]=-802,[4]=1},[2]={[1]="1a0f8294f7d.png",[2]=400,[3]=-802,[4]=1}},["width"]=800.0,["height"]=400.0}
catalog["1273590666-10080-25"] = {["pieces"]={[1]={[1]="1a0f82908c2.png",[2]=-800,[3]=-791,[4]=1},[2]={[1]="1a0f82921eb.png",[2]=600,[3]=-791,[4]=1}},["width"]=1200.0,["height"]=400.0}
catalog["1145050908-40142-53"] = {["pieces"]={[1]={[1]="1a0f8284ecf.png",[2]=-800,[3]=-800,[4]=1},[2]={[1]="1a0f8286554.png",[2]=800,[3]=-800,[4]=1}},["width"]=1600.0,["height"]=400.0}
catalog["907925187-725-41"] = {["pieces"]={[1]={[1]="1a0f8287c1f.png",[2]=-800,[3]=-802,[4]=1},[2]={[1]="1a0f8289399.png",[2]=900,[3]=-802,[4]=1}},["width"]=1800.0,["height"]=400.0}
catalog["1691160087-394-41"] = {["pieces"]={[1]={[1]="1a0f828aaff.png",[2]=-800,[3]=-800,[4]=1},[2]={[1]="1a0f828c271.png",[2]=600,[3]=-800,[4]=1}},["width"]=1200.0,["height"]=400.0}
catalog["1005367829-10203-25"] = {["pieces"]={[1]={[1]="1a0f828d9e3.png",[2]=-800,[3]=-800,[4]=1},[2]={[1]="1a0f828f155.png",[2]=900,[3]=-800,[4]=1}},["width"]=1800.0,["height"]=400.0}
catalog["1730966166-46233-40"] = {["pieces"]={[1]={[1]="1a0f82a997b.png",[2]=-800,[3]=-754,[4]=1},[2]={[1]="1a0f82aaf68.png",[2]=400,[3]=-754,[4]=1}},["width"]=800.0,["height"]=400.0}
catalog["458222008-26071-32"] = {["pieces"]={[1]={[1]="1a0f82a6875.png",[2]=-800,[3]=-797,[4]=1},[2]={[1]="1a0f82a7fe4.png",[2]=600,[3]=-797,[4]=1}},["width"]=1200.0,["height"]=400.0}
catalog["1705202265-26455-56"] = {["pieces"]={[1]={[1]="1a0f829668e.png",[2]=-800,[3]=-756,[4]=1},[2]={[1]="1a0f8297e04.png",[2]=800,[3]=-756,[4]=1},[3]={[1]="1a0f829956e.png",[2]=800,[3]=144,[4]=1}},["width"]=1600.0,["height"]=400.0}
catalog["984482707-61743-44"] = {["pieces"]={[1]={[1]="1a0f829acdf.png",[2]=-800,[3]=-765,[4]=1},[2]={[1]="1a0f829c456.png",[2]=900,[3]=-765,[4]=1}},["width"]=1800.0,["height"]=400.0}
catalog["507428460-58064-44"] = {["pieces"]={[1]={[1]="1a0f829dbbf.png",[2]=-800,[3]=-760,[4]=1},[2]={[1]="1a0f829f337.png",[2]=600,[3]=-760,[4]=1}},["width"]=1200.0,["height"]=400.0}
catalog["386679188-27818-32"] = {["pieces"]={[1]={[1]="1a0f82a0a99.png",[2]=-800,[3]=-759,[4]=1},[2]={[1]="1a0f82a220f.png",[2]=-800,[3]=141,[4]=1},[3]={[1]="1a0f82a397b.png",[2]=900,[3]=-759,[4]=1},[4]={[1]="1a0f82a50fc.png",[2]=900,[3]=141,[4]=1}},["width"]=1800.0,["height"]=400.0}
catalog["767753377-48959-40"] = {["pieces"]={[1]={[1]="1a0f833c658.png",[2]=-800,[3]=-794,[4]=1},[2]={[1]="1a0f833ddc8.png",[2]=400,[3]=-794,[4]=1}},["width"]=800.0,["height"]=400.0}
catalog["998373879-22995-31"] = {["pieces"]={[1]={[1]="1a0f833688c.png",[2]=-800,[3]=-780,[4]=1},[2]={[1]="1a0f8337ff8.png",[2]=-800,[3]=120,[4]=1},[3]={[1]="1a0f8339769.png",[2]=600,[3]=-780,[4]=1},[4]={[1]="1a0f833aedb.png",[2]=600,[3]=120,[4]=1}},["width"]=1200.0,["height"]=400.0}
catalog["66756022-20743-53"] = {["pieces"]={[1]={[1]="1a0f82ac6d7.png",[2]=-800,[3]=-782,[4]=1},[2]={[1]="1a0f82ade4a.png",[2]=-800,[3]=118,[4]=1},[3]={[1]="1a0f82af5b5.png",[2]=800,[3]=-782,[4]=1},[4]={[1]="1a0f82b0d24.png",[2]=800,[3]=118,[4]=1}},["width"]=1600.0,["height"]=400.0}
catalog["966837684-54975-42"] = {["pieces"]={[1]={[1]="1a0f82b249f.png",[2]=-800,[3]=-793,[4]=1},[2]={[1]="1a0f82b3c08.png",[2]=-800,[3]=107,[4]=1},[3]={[1]="1a0f83280c6.png",[2]=900,[3]=-793,[4]=1},[4]={[1]="1a0f832964e.png",[2]=900,[3]=107,[4]=1}},["width"]=1800.0,["height"]=400.0}
catalog["76088704-54372-42"] = {["pieces"]={[1]={[1]="1a0f832acfa.png",[2]=-800,[3]=-802,[4]=1},[2]={[1]="1a0f832c46d.png",[2]=-800,[3]=98,[4]=1},[3]={[1]="1a0f832dbde.png",[2]=600,[3]=-802,[4]=1},[4]={[1]="1a0f832f37a.png",[2]=600,[3]=98,[4]=1}},["width"]=1200.0,["height"]=400.0}
catalog["226361810-23439-31"] = {["pieces"]={[1]={[1]="1a0f8330ac0.png",[2]=-800,[3]=-799,[4]=1},[2]={[1]="1a0f8332229.png",[2]=-800,[3]=101,[4]=1},[3]={[1]="1a0f83339ad.png",[2]=900,[3]=-799,[4]=1},[4]={[1]="1a0f8335121.png",[2]=900,[3]=101,[4]=1}},["width"]=1800.0,["height"]=400.0}
catalog["1217429391-47988-40"] = {["pieces"]={[1]={[1]="1a0f835ca43.png",[2]=-800,[3]=-739,[4]=1},[2]={[1]="1a0f835e1b3.png",[2]=-800,[3]=161,[4]=1},[3]={[1]="1a0f835f924.png",[2]=400,[3]=-739,[4]=1},[4]={[1]="1a0f8361095.png",[2]=400,[3]=161,[4]=1}},["width"]=800.0,["height"]=400.0}
catalog["171090748-30688-33"] = {["pieces"]={[1]={[1]="1a0f8356c46.png",[2]=-800,[3]=-705,[4]=1},[2]={[1]="1a0f83586cf.png",[2]=-800,[3]=195,[4]=1},[3]={[1]="1a0f8359b81.png",[2]=600,[3]=-705,[4]=1},[4]={[1]="1a0f835b2ce.png",[2]=600,[3]=195,[4]=1}},["width"]=1200.0,["height"]=400.0}
catalog["422089550-31232-57"] = {["pieces"]={[1]={[1]="1a0f833f541.png",[2]=-800,[3]=-737,[4]=1},[2]={[1]="1a0f8340ca5.png",[2]=-800,[3]=163,[4]=1},[3]={[1]="1a0f8342416.png",[2]=800,[3]=-737,[4]=1},[4]={[1]="1a0f8343b7d.png",[2]=800,[3]=163,[4]=1}},["width"]=1600.0,["height"]=400.0}
catalog["64782262-1156-45"] = {["pieces"]={[1]={[1]="1a0f83452ff.png",[2]=-800,[3]=-732,[4]=1},[2]={[1]="1a0f8346a6e.png",[2]=-800,[3]=168,[4]=1},[3]={[1]="1a0f83481d9.png",[2]=900,[3]=-732,[4]=1},[4]={[1]="1a0f8349942.png",[2]=900,[3]=168,[4]=1}},["width"]=1800.0,["height"]=400.0}
catalog["1954301682-62190-45"] = {["pieces"]={[1]={[1]="1a0f834b0ba.png",[2]=-800,[3]=-713,[4]=1},[2]={[1]="1a0f834c82b.png",[2]=-800,[3]=187,[4]=1},[3]={[1]="1a0f834df9f.png",[2]=600,[3]=-713,[4]=1},[4]={[1]="1a0f834f70f.png",[2]=600,[3]=187,[4]=1}},["width"]=1200.0,["height"]=400.0}
catalog["1010591868-32076-33"] = {["pieces"]={[1]={[1]="1a0f8350e86.png",[2]=-800,[3]=-772,[4]=1},[2]={[1]="1a0f8352600.png",[2]=-800,[3]=128,[4]=1},[3]={[1]="1a0f8353d63.png",[2]=900,[3]=-772,[4]=1},[4]={[1]="1a0f83554da.png",[2]=900,[3]=128,[4]=1}},["width"]=1800.0,["height"]=400.0}
catalog["1154021664-41050-38"] = {["pieces"]={[1]={[1]="1a0f837f860.png",[2]=-800,[3]=-671,[4]=1},[2]={[1]="1a0f83812fe.png",[2]=400,[3]=-671,[4]=1}},["width"]=800.0,["height"]=400.0}
catalog["1518405818-27700-33"] = {["pieces"]={[1]={[1]="1a0f837c99a.png",[2]=-800,[3]=-673,[4]=1},[2]={[1]="1a0f837e0f2.png",[2]=600,[3]=-673,[4]=1}},["width"]=1200.0,["height"]=400.0}
catalog["979178964-30070-57"] = {["pieces"]={[1]={[1]="1a0f836c7a0.png",[2]=-800,[3]=-631,[4]=1},[2]={[1]="1a0f836df0d.png",[2]=800,[3]=-631,[4]=1}},["width"]=1600.0,["height"]=400.0}
catalog["1701076885-62009-45"] = {["pieces"]={[1]={[1]="1a0f836f678.png",[2]=-800,[3]=-651,[4]=1},[2]={[1]="1a0f8370de5.png",[2]=-800,[3]=249,[4]=1},[3]={[1]="1a0f837255c.png",[2]=900,[3]=-651,[4]=1},[4]={[1]="1a0f8373cca.png",[2]=900,[3]=249,[4]=1}},["width"]=1800.0,["height"]=400.0}
catalog["1412787987-61468-45"] = {["pieces"]={[1]={[1]="1a0f837544c.png",[2]=-800,[3]=-645,[4]=1},[2]={[1]="1a0f8376bbc.png",[2]=600,[3]=-645,[4]=1}},["width"]=1200.0,["height"]=400.0}
catalog["490462914-28147-33"] = {["pieces"]={[1]={[1]="1a0f837832f.png",[2]=-800,[3]=-696,[4]=1},[2]={[1]="1a0f8379a93.png",[2]=900,[3]=-696,[4]=1},[3]={[1]="1a0f837b203.png",[2]=900,[3]=204,[4]=1}},["width"]=1800.0,["height"]=400.0}
catalog["1327270132-65364-24"] = {["pieces"]={[1]={[1]="1a0f838d063.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0cfe2275d.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0da60f02a.png",[2]=400,[3]=-1000,[4]=1},[4]={[1]="1a0da61079f.png",[2]=400,[3]=200,[4]=1}},["width"]=800.0,["height"]=400.0}
catalog["966444991-49547-44"] = {["pieces"]={[1]={[1]="1a0d9c20ff9.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0f8395d13.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0d9c8719f.png",[2]=-290,[3]=200,[4]=1},[4]={[1]="1a0d9c18354.png",[2]=800,[3]=-1000,[4]=1},[5]={[1]="1a0d9c19ab7.png",[2]=800,[3]=200,[4]=1},[6]={[1]="1a0d9c9e8b3.png",[2]=1890,[3]=200,[4]=1}},["width"]=1600.0,["height"]=400.0}
catalog["1545905817-821-24"] = {["pieces"]={[1]={[1]="1a0da5fbf65.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0da5f9082.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0da5f790c.png",[2]=400,[3]=-1000,[4]=1},[4]={[1]="1a0f838e7e0.png",[2]=400,[3]=200,[4]=1}},["width"]=800.0,["height"]=400.0}
catalog["832829552-31457-36"] = {["pieces"]={[1]={[1]="1a0da0b3694.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0da09ee52.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0f838ff52.png",[2]=800,[3]=-1000,[4]=1},[4]={[1]="1a0da0ac14d.png",[2]=800,[3]=200,[4]=1}},["width"]=1600.0,["height"]=400.0}
catalog["261857337-60945-47"] = {["pieces"]={[1]={[1]="1a0f83916c5.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0d9d597e0.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0d9d5c6c1.png",[2]=800,[3]=-1000,[4]=1},[4]={[1]="1a0d9d568fd.png",[2]=800,[3]=200,[4]=1}},["width"]=1600.0,["height"]=400.0}
catalog["994962547-31312-57"] = {["pieces"]={[1]={[1]="1a0d9d0ba13.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0d9d18d5b.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0d9d2f000.png",[2]=800,[3]=-1000,[4]=1},[4]={[1]="1a0f8392e35.png",[2]=800,[3]=200,[4]=1}},["width"]=1600.0,["height"]=400.0}
catalog["686773498-50234-45"] = {["pieces"]={[1]={[1]="1a0d9cb7983.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0d9d05c4d.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0d9cfcfa2.png",[2]=-290,[3]=200,[4]=1},[4]={[1]="1a0d9ceb4b8.png",[2]=800,[3]=-1000,[4]=1},[5]={[1]="1a0f83945a1.png",[2]=800,[3]=200,[4]=1},[6]={[1]="1a0d9cf415f.png",[2]=1890,[3]=200,[4]=1}},["width"]=1600.0,["height"]=400.0}
catalog["1033935322-46612-41"] = {["pieces"]={[1]={[1]="1a0f839edd7.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0da4e7349.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0da4fd405.png",[2]=400,[3]=-1000,[4]=1},[4]={[1]="1a0da4ee895.png",[2]=400,[3]=200,[4]=1}},["width"]=800.0,["height"]=400.0}
catalog["1549043415-38799-62"] = {["pieces"]={[1]={[1]="1a0da4f1757.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0da4f463e.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0f83a0213.png",[2]=400,[3]=-1000,[4]=1},[4]={[1]="1a0f83a198c.png",[2]=400,[3]=200,[4]=1}},["width"]=800.0,["height"]=400.0}
catalog["525795544-27176-58"] = {["pieces"]={[1]={[1]="1a0da57b347.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0f839bae1.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0da569932.png",[2]=400,[3]=-1000,[4]=1},[4]={[1]="1a0da5725dc.png",[2]=400,[3]=200,[4]=1}},["width"]=800.0,["height"]=400.0}
catalog["859503558-49629-64"] = {["pieces"]={[1]={[1]="1a0da559750.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0da5623ff.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0f839d251.png",[2]=400,[3]=-1000,[4]=1},[4]={[1]="1a0da550aa8.png",[2]=400,[3]=200,[4]=1}},["width"]=800.0,["height"]=400.0}
catalog["591573356-9885-27"] = {["pieces"]={[1]={[1]="1a0f839a371.png",[2]=-1375.8281250000002,[3]=-913.549584460219,[4]=2.3177083333333335,["scaleY"]=1.8067227343698549}},["width"]=800.0,["height"]=400.0}
catalog["407195134-12743-28"] = {["pieces"]={[1]={[1]="1a0f8398bfa.png",[2]=-1374.5859375,[3]=-1001.9739468778951,[4]=2.578125,["scaleY"]=1.9587569497125945}},["width"]=1200.0,["height"]=400.0}
catalog["360829589-43147-39"] = {["pieces"]={[1]={[1]="1a0f83a30fc.png",[2]=-1136.0,[3]=-861,[4]=2,["scaleY"]=2}},["width"]=800.0,["height"]=400.0}
catalog["2047857447-48301-40"] = {["pieces"]={[1]={[1]="1a0f83a30fc.png",[2]=-936.0,[3]=-861,[4]=2,["scaleY"]=2}},["width"]=1200.0,["height"]=400.0}
catalog["1290976541-39740-39"] = {["pieces"]={[1]={[1]="1a0da069b52.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0da091b53.png",[2]=-290,[3]=-1000,[4]=1},[3]={[1]="1a0da062770.png",[2]=-1380,[3]=200,[4]=1},[4]={[1]="1a0da08bd9b.png",[2]=800,[3]=-1000,[4]=1},[5]={[1]="1a0da05c7fa.png",[2]=800,[3]=200,[4]=1},[6]={[1]="1a0f839747c.png",[2]=367.7314211212516,[3]=249.02216427640155,[4]=0.0651890482398957},[7]={[1]="1a0f839747c.png",[2]=767.7314211212516,[3]=249.02216427640155,[4]=0.0651890482398957},[8]={[1]="1a0f839747c.png",[2]=1167.7314211212515,[3]=249.02216427640155,[4]=0.0651890482398957}},["width"]=1600.0,["height"]=400.0}
catalog["947432607-7939-27"] = {["pieces"]={[1]={[1]="1a0da6335f7.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0da637c42.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0da631e7a.png",[2]=600,[3]=-1000,[4]=1},[4]={[1]="1a0da6364cf.png",[2]=600,[3]=200,[4]=1},[5]={[1]="1a0f839747c.png",[2]=366.76336375488916,[3]=248.9928292046936,[4]=0.06714471968709257},[6]={[1]="1a0f839747c.png",[2]=766.7633637548892,[3]=248.9928292046936,[4]=0.06714471968709257}},["width"]=1200.0,["height"]=400.0}
catalog["1818935705-57608-21"] = {["pieces"]={[1]={[1]="1a0cfe19b6a.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0cfe311cc.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0cfe39e5d.png",[2]=400,[3]=-1000,[4]=1},[4]={[1]="1a0cfe29c95.png",[2]=400,[3]=200,[4]=1},[5]={[1]="1a0f839747c.png",[2]=367.7314211212516,[3]=250.02216427640155,[4]=0.0651890482398957}},["width"]=800.0,["height"]=400.0}
published["@7984790"] = catalog["2074728831-42326-38"]
published["@7984791"] = catalog["1273590666-10080-25"]
published["@7984792"] = catalog["1145050908-40142-53"]
published["@7984793"] = catalog["907925187-725-41"]
published["@7984794"] = catalog["1691160087-394-41"]
published["@7984795"] = catalog["1730966166-46233-40"]
published["@7984796"] = catalog["458222008-26071-32"]
published["@7984797"] = catalog["1705202265-26455-56"]
published["@7984798"] = catalog["984482707-61743-44"]
published["@7984799"] = catalog["507428460-58064-44"]
published["@7984800"] = catalog["767753377-48959-40"]
published["@7984801"] = catalog["998373879-22995-31"]
published["@7984802"] = catalog["66756022-20743-53"]
published["@7984803"] = catalog["966837684-54975-42"]
published["@7984804"] = catalog["76088704-54372-42"]
published["@7984805"] = catalog["1217429391-47988-40"]
published["@7984806"] = catalog["171090748-30688-33"]
published["@7984807"] = catalog["422089550-31232-57"]
published["@7984808"] = catalog["64782262-1156-45"]
published["@7984809"] = catalog["1954301682-62190-45"]
published["@7984769"] = catalog["1154021664-41050-38"]
published["@7984770"] = catalog["1518405818-27700-33"]
published["@7984771"] = catalog["979178964-30070-57"]
published["@7984772"] = catalog["1701076885-62009-45"]
published["@7984773"] = catalog["1412787987-61468-45"]
published["@7984900"] = catalog["1327270132-65364-24"]
published["@7985231"] = catalog["966444991-49547-44"]
published["@7984877"] = catalog["1545905817-821-24"]
published["@7984910"] = catalog["832829552-31457-36"]
published["@7984906"] = catalog["261857337-60945-47"]
published["@7984948"] = catalog["994962547-31312-57"]
published["@7985007"] = catalog["686773498-50234-45"]
published["@7984995"] = catalog["1033935322-46612-41"]
published["@7985017"] = catalog["1549043415-38799-62"]
published["@7985019"] = catalog["525795544-27176-58"]
published["@7985021"] = catalog["859503558-49629-64"]
published["@7984865"] = catalog["591573356-9885-27"]
published["@7984866"] = catalog["407195134-12743-28"]
published["@7984937"] = catalog["360829589-43147-39"]
published["@7984938"] = catalog["2047857447-48301-40"]
published["@7985196"] = catalog["1290976541-39740-39"]
published["@7985277"] = catalog["947432607-7939-27"]
published["@7985198"] = catalog["1818935705-57608-21"]

-- Additional uploads verified against XML-aligned exports, 2026-10-01.
catalog["969611748-13931-29"] = {["pieces"]={[1]={[1]="1a0f8b5ed00.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0f8b60198.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0f8b618f6.png",[2]=400,[3]=-1000,[4]=1},[4]={[1]="1a0f8b6307a.png",[2]=400,[3]=200,[4]=1}},["width"]=800.0,["height"]=400.0}
catalog["122964921-14474-29"] = {["pieces"]={[1]={[1]="1a0f8b647ea.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0f8b65f60.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0f8b676c4.png",[2]=600,[3]=-1000,[4]=1},[4]={[1]="1a0f8b68e41.png",[2]=600,[3]=200,[4]=1}},["width"]=1200.0,["height"]=400.0}
catalog["1499850571-53211-44"] = {["pieces"]={[1]={[1]="1a0f8b6a5aa.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0f8b6bd17.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0f8b6d48c.png",[2]=800,[3]=-1000,[4]=1},[4]={[1]="1a0f8b6ec08.png",[2]=800,[3]=200,[4]=1}},["width"]=1600.0,["height"]=400.0}
catalog["1086810883-32255-36"] = {["pieces"]={[1]={[1]="1a0f8b647ea.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0f8b65f60.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0f8b676c4.png",[2]=600,[3]=-1000,[4]=1},[4]={[1]="1a0f8b68e41.png",[2]=600,[3]=200,[4]=1}},["width"]=1200.0,["height"]=400.0}
catalog["1137924375-926-24"] = {["pieces"]={[1]={[1]="1a0f8b7036a.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0f8b71ae4.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0f8b7324e.png",[2]=900,[3]=-1000,[4]=1},[4]={[1]="1a0f8b749ce.png",[2]=900,[3]=200,[4]=1}},["width"]=1800.0,["height"]=400.0}
catalog["2079965383-13046-28"] = {["pieces"]={[1]={[1]="1a0f8b76135.png",[2]=-1380,[3]=-1000,[4]=1},[2]={[1]="1a0f8b778a5.png",[2]=-1380,[3]=200,[4]=1},[3]={[1]="1a0f8b7901c.png",[2]=-40,[3]=-1000,[4]=1},[4]={[1]="1a0f8b7a78b.png",[2]=1300,[3]=-1000,[4]=1},[5]={[1]="1a0f8b7bf02.png",[2]=2640,[3]=-1000,[4]=1}},["width"]=2600.0,["height"]=400.0}
catalog["1005367829-10203-25"] = {["pieces"]={[1]={[1]="1a0f8b7d67b.png",[2]=-800,[3]=-800,[4]=1},[2]={[1]="1a0f8b7ede4.png",[2]=900,[3]=-800,[4]=1}},["width"]=1800.0,["height"]=400.0}
published["@7985245"] = catalog["969611748-13931-29"]
published["@7985246"] = catalog["122964921-14474-29"]
published["@7985247"] = catalog["1499850571-53211-44"]
published["@7985248"] = catalog["1086810883-32255-36"]

local active, personal, shown = nil, {}, {}
local hidden, broadcast = {}, nil
local status = "waiting for a gameplay map"
local sent = 0
local attributes = {'T','X','Y','L','H','P','c','o'}

-- Native-size PNGs match the original 14px marker without textarea borders.
mapBackgrounds.borderImages = {'1a0f8be4795.png', '1a0f8be3022.png'} -- Left, right; native 14px width.
local bordersDrawn, borderRects = false, {}
local hiddenBorders, borderPersonal, borderShown = {}, {}, {}
local borderShared

local function clearBorders(name)
  for _, id in ipairs(borderPersonal[name] or {}) do tfm.exec.removeImage(id) end
  borderPersonal[name], borderShown[name] = nil, nil
end

function mapBackgrounds.showBorders(name)
  if not bordersDrawn or mapBackgrounds.borderImages[1]=='' or mapBackgrounds.borderImages[2]=='' then return end
  if name and (hiddenBorders[name] or borderShown[name] or not tfm.get.room.playerList[name]) then return end
  if name and borderShared then borderShown[name]=true; return end
  if not name then
    if borderShared then return end
    for player in pairs(tfm.get.room.playerList) do
      if hiddenBorders[player] then
        for viewer in pairs(tfm.get.room.playerList) do mapBackgrounds.showBorders(viewer) end
        return
      end
    end
  end
  local ids={}
  for i,r in ipairs(borderRects) do
    -- Width always 1:1; height follows the XML court. No extra padding.
    local id=tfm.exec.addImage(mapBackgrounds.borderImages[i],'!1000',r.x,0,name,1,r.height/400,0,1,0,0)
    if id then ids[#ids+1]=id end
  end
  if name then borderPersonal[name],borderShown[name]=ids,true
  else
    borderShared=ids
    for player in pairs(tfm.get.room.playerList) do borderShown[player]=true end
  end
end

function mapBackgrounds.bordersHidden(name) return hiddenBorders[name]==true end

function mapBackgrounds.toggleBorders(name)
  if not tfm.get.room.playerList[name] then return end
  hiddenBorders[name]=not hiddenBorders[name] or nil
  if borderShared then
    for _,id in ipairs(borderShared) do tfm.exec.removeImage(id) end
    borderShared=nil
    for viewer in pairs(tfm.get.room.playerList) do
      clearBorders(viewer);mapBackgrounds.showBorders(viewer)
    end
  else clearBorders(name);mapBackgrounds.showBorders(name) end
end

local function drawCourtBorders(xml, width, height)
  if bordersDrawn then return end
  local edges, distances = {0, width}, {math.huge, math.huge}
  for tag in xml:gmatch('<S%s+[^>]*>') do
    local x = tonumber(mapXml.attribute(tag, 'X'))
    local y = tonumber(mapXml.attribute(tag, 'Y'))
    local w = tonumber(mapXml.attribute(tag, 'L'))
    local h = tonumber(mapXml.attribute(tag, 'H'))
    local kind = tonumber(mapXml.attribute(tag, 'T'))
    local collision = mapXml.attribute(tag, 'c')
    local physics = {}
    for value in ((mapXml.attribute(tag, 'P') or '') .. ','):gmatch('(.-),') do
      physics[#physics + 1] = tonumber(value) or 0
    end
    if x and y and w and h and kind ~= 13 and kind ~= 9
      and collision ~= '4' and (physics[1] or 0) == 0
      and (physics[5] or 0) % 180 == 0
      and w <= 100 and h >= height * 0.75
      and y - h / 2 <= height * 0.25 and y + h / 2 >= height * 0.75 then
      local faces = {x + w / 2, x - w / 2}
      for side = 1, 2 do
        local target = side == 1 and 0 or width
        local distance = math.abs(faces[side] - target)
        if distance <= 80 and distance < distances[side] then
          edges[side], distances[side] = faces[side], distance
        end
      end
    end
  end
  for side,x in ipairs(edges) do
    borderRects[side]={x=x+(side==1 and -14 or 0),height=height}
  end
  bordersDrawn=true
  mapBackgrounds.showBorders()
end

local function geometryKey(xml)
  local params = xml:match('<P%s+[^>]*>') or ''
  local values = {(mapXml.attribute(params, 'L') or '800') .. '|' ..
    (mapXml.attribute(params, 'H') or '400') .. ';'}
  local count = 0
  for tag in xml:gmatch('<S%s+[^>]*>') do
    count = count + 1
    local fields = {}
    for i, key in ipairs(attributes) do fields[i] = mapXml.attribute(tag, key) or '' end
    values[#values + 1] = table.concat(fields, '|') .. ';'
  end
  local hash, check = 0, 0
  local value = table.concat(values)
  for i = 1, #value do
    local byte = value:byte(i)
    hash = (hash * 31 + byte) % 2147483647
    check = (check + byte) % 65521
  end
  return string.format('%.0f-%.0f-%d', hash, check, count)
end

function mapBackgrounds.newGame()
  floorVisuals.newGame()
  -- Images from the previous map have already been removed by the host.
  active, personal, shown = nil, {}, {}
  broadcast = nil
  sent = 0
  bordersDrawn, borderRects = false, {}
  borderPersonal,borderShown,borderShared={},{},nil
end

function mapBackgrounds.clearPlayer(name)
  floorVisuals.clearPlayer(name)
  local ids = personal[name]
  if ids then
    for _, id in ipairs(ids) do tfm.exec.removeImage(id) end
  end
  personal[name], shown[name] = nil, nil
end

function mapBackgrounds.show(name)
  if name and hidden[name] then floorVisuals.show(name) end
  if not active or (name and (shown[name] or hidden[name])) then return end
  if not name then
    for player in pairs(tfm.get.room.playerList) do
      if hidden[player] then
        for viewer in pairs(tfm.get.room.playerList) do mapBackgrounds.show(viewer) end
        return
      end
    end
  end
  local ids = {}
  for _, piece in ipairs(active.pieces) do
    local id = tfm.exec.addImage(piece[1], piece.layer or '?1000', piece[2], piece[3], name,
      piece[4], piece.scaleY or piece[4], 0, 1, 0, 0)
    if id then ids[#ids + 1] = id end
  end
  sent = #ids
  if name then
    personal[name], shown[name] = ids, true
  else
    broadcast = ids
    -- Broadcast when everybody wants backgrounds; retain the cheap default path.
    for player in pairs(tfm.get.room.playerList) do shown[player] = true end
  end
end

function mapBackgrounds.isHidden(name) return hidden[name] == true end

function mapBackgrounds.toggleHidden(name)
  if not tfm.get.room.playerList[name] then return end
  hidden[name] = not hidden[name] or nil
  if broadcast then
    -- A shared image cannot be removed for one viewer only.
    for _, id in ipairs(broadcast) do tfm.exec.removeImage(id) end
    broadcast = nil
    for viewer in pairs(tfm.get.room.playerList) do
      mapBackgrounds.clearPlayer(viewer)
      mapBackgrounds.show(viewer)
    end
  else
    mapBackgrounds.clearPlayer(name)
    mapBackgrounds.show(name)
  end
end

function mapBackgrounds.leave(name)
  mapBackgrounds.clearPlayer(name)
  hidden[name], hiddenBorders[name] = nil, nil
  clearBorders(name)
end

function mapBackgrounds.refresh(name)
  if not active or not name then return false end
  local now = os.time()
  if type(shown[name]) == 'number' and now - shown[name] < 5000 then return false end
  mapBackgrounds.clearPlayer(name)
  mapBackgrounds.show(name)
  shown[name] = now
  return true
end

function mapBackgrounds.prepare()
  local info = tfm.get.room.xmlMapInfo
  if not info or type(info.xml) ~= 'string' then return false end
  floorVisuals.setXML(info.xml)
  for name in pairs(hidden) do floorVisuals.show(name) end
  local params = info.xml:match('<P%s+[^>]*>') or ''
  local width = tonumber(mapXml.attribute(params, 'L')) or 800
  local height = tonumber(mapXml.attribute(params, 'H')) or 400
  local code = tostring(gameState.map.sourceTarget or tfm.get.room.currentMap)
  if code:sub(1, 1) ~= '@' then code = '@' .. code end
  local entry = published[code] or catalog[geometryKey(info.xml)]
  -- Maps whose side indicators have been disabled in every variant.
  local noBorders = entry and (entry == catalog["1173766353-12112-50"]
    or entry == catalog["140145077-57552-43"]
    or entry == catalog["600319957-37260-36"]
    or entry == catalog["511300641-6322-52"]
    or entry == catalog["1317108441-58308-47"]
    or entry == catalog["1787514854-44520-42"]
    or entry == catalog["359639136-45139-42"]
    or entry == catalog["1128677027-50880-44"]
    or entry == catalog["1224312110-23038-33"]
    or entry == catalog["578030013-23555-33"]
    or entry == catalog["1023816945-42085-40"]
    or entry == catalog["48666429-20590-30"]
    or entry == catalog["297192898-38457-36"]
    or entry == catalog["265867957-54335-42"]
    or entry == catalog["943467518-34411-35"])
  -- Honeymoon's four-team background is not uploaded yet.
  noBorders = noBorders or code == '@7984904' or code == '@7984905'
    or code == '@7984906' or code == '@7984907'
  -- Match live catalog targets so exclusions follow map reuploads and mode variants.
  local excludedNames = {['quad cannons']=true, ['top player']=true,
    chaos=true, lacostes=true, handball=true, squad=true}
  for _, maps in ipairs({customMaps, customMapsThreeTeamsMode, customMapsFourTeamsMode}) do
    for _, map in ipairs(maps) do
      local name = type(map[3]) == 'string' and map[3]:lower() or ''
      local allVariants = excludedNames[name] or name:find('soccer', 1, true)
      local dustyTwoAlive = maps == customMapsFourTeamsMode and name == 'dusty journey'
      if allVariants or dustyTwoAlive then
        for _, slot in ipairs({1, 2, 5, 'twoTeams', 'extraLarge'}) do
          local target = (allVariants or slot == 5) and map[slot]
          if type(target) == 'string' and (target == code or target == info.xml
            or (entry and published[target] == entry)) then
            noBorders = true
          end
        end
      end
    end
  end
  if not noBorders then drawCourtBorders(info.xml, width, height) end
  if globalSettings.minimalist then status = "minimalist enabled"; return false end
  if not entry then status = "no complete background for this map"; return false end
  if (tonumber(mapXml.attribute(params, 'L')) or 800) ~= entry.width
    or (tonumber(mapXml.attribute(params, 'H')) or 400) ~= entry.height then
    status = "map dimensions differ from the export"; return false
  end
  -- Add artwork only. Preserve the native XML, backgrounds and ground visibility.
  status = "background requested"
  active = entry
  mapBackgrounds.show()
  return false
end

function mapBackgrounds.diagnose(name)
  local code = tostring(gameState.map.sourceTarget or tfm.get.room.currentMap)
  if code:sub(1,1) == '<' then code = 'XML' end
  tfm.exec.chatMessage('<j>BACKGROUND: map=' .. code .. ' status=' .. status ..
    ' images=' .. tostring(sent) .. '/' .. tostring(active and #active.pieces or 0) .. '<n>', name)
end

end
