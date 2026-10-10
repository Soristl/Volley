-- Uploaded backgrounds, matched against the final local PNG pixels.
-- Each scene is defined once; its geometry aliases and published codes share
-- the same table. Keep distinct scenes separate even when artwork is identical.
mapBackgrounds = {}
do
local catalog, published = {}, {}

-- 4T-4-vivantes/water-cannon
do
  local scene = {
    hideBorders=true,
    width=1600, height=400,
    pieces={
      {"1a0d9c125ad.png", -1380, -1000, 1},
      {"1a0d9c7fd5d.png", 800, -1000, 1},
    },
  }
  catalog["511300641-6322-52"] = scene
  published["@7984843"] = scene
end

-- 4T-3-vivantes/water-cannon
do
  local scene = {
    hideBorders=true,
    width=1200, height=400,
    pieces={
      {"1a0da18d36b.png", -1380, -1000, 1},
      {"1a0da1875a5.png", 600, -1000, 1},
    },
  }
  catalog["1317108441-58308-47"] = scene
  published["@7984845"] = scene
end

-- 4T-2-vivantes/water-cannon
do
  local scene = {
    hideBorders=true,
    width=800, height=400,
    pieces={
      {"1a0cfa9fb01.png", -1380, -1000, 1},
      {"1a0cfa76687.png", 400, -1000, 1},
    },
  }
  catalog["1787514854-44520-42"] = scene
  published["@7984841"] = scene
end

-- 4T-4-vivantes/ice-barrier
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9d4f522.png", -1380, -1000, 1},
      {"1a0d9d5229d.png", -1380, 200, 1},
      {"1a0d9d55183.png", 800, -1000, 1},
      {"1a0d9d37ca7.png", 800, 200, 1},
    },
  }
  catalog["1255615608-31934-36"] = scene
  published["@7985236"] = scene
end

-- 4T-3-vivantes/ice-barrier
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0d9bd12cc.png", -1380, -1000, 1},
      {"1a0da39771b.png", -1380, 200, 1},
      {"1a0da39d4e1.png", 600, -1000, 1},
      {"1a0da39a600.png", 600, 200, 1},
    },
  }
  catalog["33464961-16018-30"] = scene
  published["@7985238"] = scene
end

-- 4T-2-vivantes/ice-barrier
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfc119f7.png", -1380, -1000, 1},
      {"1a0cfc017fa.png", -1380, 200, 1},
      {"1a0cfc0a49f.png", 400, -1000, 1},
      {"1a0da60a9d2.png", 400, 200, 1},
    },
  }
  catalog["1621442174-60348-22"] = scene
  published["@7985234"] = scene
end

-- 4T-4-vivantes/sky-circles
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9cb6219.png", -1380, -1000, 1},
      {"1a0d9cf29f8.png", -1380, 200, 1},
      {"1a0d9ce9d46.png", 800, -1000, 1},
      {"1a0d9d044e6.png", 800, 200, 1},
    },
  }
  catalog["2104810837-42608-39"] = scene
  published["@7985219"] = scene
  catalog["1761457080-42548-39"] = scene
  published["@7985745"] = scene
end

-- 4T-3-vivantes/sky-circles
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da207295.png", -1380, -1000, 1},
      {"1a0da1f41cd.png", -1380, 200, 1},
      {"1a0da20d05b.png", 600, -1000, 1},
      {"1a0da1f70b6.png", 600, 200, 1},
    },
  }
  catalog["718434695-26197-33"] = scene
  published["@7985220"] = scene
  catalog["1535649143-26137-33"] = scene
  published["@7985746"] = scene
end

-- 4T-2-vivantes/sky-circles
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfac1ebe.png", -1380, -1000, 1},
      {"1a0cfadd65b.png", -1380, 200, 1},
      {"1a0cfae6470.png", 400, -1000, 1},
      {"1a0cfab8b8e.png", 400, 200, 1},
    },
  }
  catalog["1487777147-1304-24"] = scene
  published["@7984824"] = scene
end

-- 4T-4-vivantes/sky-trampolines
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9ce85d1.png", -1380, -1000, 1},
      {"1a0d9d02d6e.png", -1380, 200, 1},
      {"1a0d9cfb835.png", 800, -1000, 1},
      {"1a0d9cb4aa6.png", 800, 200, 1},
    },
  }
  catalog["989426023-86-50"] = scene
  published["@7984870"] = scene
end

-- 4T-3-vivantes/sky-trampolines
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da614de9.png", -1380, -1000, 1},
      {"1a0da61abad.png", -1380, 200, 1},
      {"1a0da61f30b.png", 600, -1000, 1},
      {"1a0da61dc19.png", 600, 200, 1},
    },
  }
  catalog["888612367-42418-41"] = scene
  published["@7984871"] = scene
end

-- 4T-2-vivantes/sky-trampolines
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfad49af.png", -1380, -1000, 1},
      {"1a0cfadbede.png", -1380, 200, 1},
      {"1a0cfae4cff.png", 400, -1000, 1},
      {"1a0cfac0752.png", 400, 200, 1},
    },
  }
  catalog["1381927082-14116-29"] = scene
  published["@7984868"] = scene
end

-- 4T-4-vivantes/bounce-diamonds
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da063e5a.png", -1380, -1000, 1},
      {"1a0da05df67.png", -1380, 200, 1},
      {"1a0da09a7f9.png", 800, -1000, 1},
      {"1a0da0932c6.png", 800, 200, 1},
    },
  }
  catalog["1241378045-39248-39"] = scene
  published["@7984902"] = scene
end

-- 4T-3-vivantes/bounce-diamonds
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da48e2c4.png", -1380, -1000, 1},
      {"1a0da486d8f.png", -1380, 200, 1},
      {"1a0da479a8d.png", 600, -1000, 1},
      {"1a0da47255e.png", 600, 200, 1},
    },
  }
  catalog["1863983187-20962-32"] = scene
  published["@7984903"] = scene
end

-- 4T-4-vivantes/black-water
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da09d6de.png", -1380, -1000, 1},
      {"1a0da097917.png", -1380, 200, 1},
      {"1a0da094a37.png", -290, 200, 1},
      {"1a0da0961a9.png", 800, -1000, 1},
      {"1a0da09bf73.png", 800, 200, 1},
      {"1a0da099087.png", 1890, 200, 1},
    },
  }
  catalog["29804111-31793-36"] = scene
  published["@7984883"] = scene
end

-- 4T-3-vivantes/black-water
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da4c86ef.png", -1380, -1000, 1},
      {"1a0da4911a2.png", -1380, 200, 1},
      {"1a0da48fa30.png", -390, 200, 1},
      {"1a0da488612.png", 600, -1000, 1},
      {"1a0da480fc1.png", 600, 200, 1},
      {"1a0da4c5ffe.png", 1590, 200, 1},
    },
  }
  catalog["1379230538-16022-30"] = scene
  published["@7984884"] = scene
end

-- 4T-2-vivantes/black-water
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfe4b86f.png", -1380, -1000, 1},
      {"1a0cfe3b5d3.png", -1380, 200, 1},
      {"1a0cfe4427d.png", 400, -1000, 1},
      {"1a0d9971752.png", 400, 200, 1},
    },
  }
  catalog["642011180-58165-21"] = scene
  published["@7984881"] = scene
end

-- 4T-4-vivantes/top-player
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9caa449.png", -1380, -1000, 1},
      {"1a0d9ca2f0c.png", -1380, 200, 1},
      {"1a0d9c92d29.png", -290, 200, 1},
      {"1a0d9cabbb4.png", 800, -1000, 1},
      {"1a0d9c8b7f0.png", 800, 200, 1},
      {"1a0d9c9a25e.png", 1890, 200, 1},
    },
  }
  catalog["1601554952-40537-39"] = scene
  published["@7984863"] = scene
end

-- 4T-3-vivantes/top-player
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da19bdd3.png", -1380, -1000, 1},
      {"1a0da190243.png", -1380, 200, 1},
      {"1a0da198eeb.png", 600, -1000, 1},
      {"1a0da1977a4.png", 600, 200, 1},
    },
  }
  catalog["266979220-29267-35"] = scene
  published["@7984864"] = scene
end

-- 4T-2-vivantes/top-player
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfa708d7.png", -1380, -1000, 1},
      {"1a0cfa985c5.png", -1380, 200, 1},
      {"1a0cfaa58c3.png", 400, -1000, 1},
      {"1a0cfab2e26.png", 400, 200, 1},
    },
  }
  catalog["445253453-126-24"] = scene
  published["@7984861"] = scene
end

-- 4T-3-vivantes/water-barrier
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da194894.png", -1380, -1000, 1},
      {"1a0da17a29a.png", -1380, 200, 1},
      {"1a0da19312d.png", 600, -1000, 1},
      {"1a0da1817cf.png", 600, 200, 1},
    },
  }
  catalog["983469419-23770-34"] = scene
  published["@7985233"] = scene
end

-- 4T-2-vivantes/water-barrier
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfaae806.png", -1380, -1000, 1},
      {"1a0cfa93f6e.png", -1380, 200, 1},
      {"1a0cfa6c3ba.png", 400, -1000, 1},
      {"1a0cfa6ac81.png", 400, 200, 1},
    },
  }
  catalog["1016735131-64892-24"] = scene
  published["@7984820"] = scene
end

-- 4T-4-vivantes/cowebs
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da0581a1.png", -1380, -1000, 1},
      {"1a0da0654fa.png", -1380, 200, 1},
      {"1a0da05f6c9.png", -290, 200, 1},
      {"1a0da06b2ca.png", 800, -1000, 1},
      {"1a0da08d500.png", 800, 200, 1},
      {"1a0da089067.png", 1890, 200, 1},
    },
  }
  catalog["1963181140-43286-41"] = scene
  published["@7984889"] = scene
end

-- 4T-3-vivantes/cowebs
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da4580b6.png", -1380, -1000, 1},
      {"1a0da3fda40.png", -1380, 200, 1},
      {"1a0da45f496.png", 600, -1000, 1},
      {"1a0da3f4d45.png", 600, 200, 1},
    },
  }
  catalog["1945054654-25171-34"] = scene
  published["@7984890"] = scene
end

-- 4T-2-vivantes/cowebs
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfe26dad.png", -1380, -1000, 1},
      {"1a0cfe1e108.png", -1380, 200, 1},
      {"1a0cfe2e2e5.png", 400, -1000, 1},
      {"1a0cfe3581e.png", 400, 200, 1},
    },
  }
  catalog["1993190275-64997-24"] = scene
  published["@7984887"] = scene
end

-- 4T-4-vivantes/ice-angle
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9d50bac.png", -1380, -1000, 1},
      {"1a0d9d5af4c.png", -1380, 200, 1},
      {"1a0d9d53a15.png", 800, -1000, 1},
      {"1a0d9d5806c.png", 800, 200, 1},
    },
  }
  catalog["581305930-42398-40"] = scene
  published["@7985209"] = scene
  catalog["642706815-42338-40"] = scene
  published["@7985705"] = scene
end

-- 4T-3-vivantes/ice-angle
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0d9bbb29f.png", -1380, -1000, 1},
      {"1a0d9bc280b.png", -1380, 200, 1},
      {"1a0d9bcb510.png", 600, -1000, 1},
      {"1a0d9bd2a41.png", 600, 200, 1},
    },
  }
  catalog["794736983-24134-33"] = scene
  published["@7985210"] = scene
  catalog["1435866066-24074-33"] = scene
  published["@7985706"] = scene
end

-- 4T-2-vivantes/ice-angle
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfc02f6f.png", -1380, -1000, 1},
      {"1a0cfc1a69e.png", -1380, 200, 1},
      {"1a0cfc0bc0e.png", 400, -1000, 1},
      {"1a0cfbfa2b9.png", 400, 200, 1},
    },
  }
  catalog["340925034-5743-26"] = scene
  published["@7985211"] = scene
  catalog["221226205-5683-26"] = scene
  published["@7985707"] = scene
end

-- 4T-4-vivantes/spin-trampolines
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9ce571e.png", -1380, -1000, 1},
      {"1a0d9cf7072.png", -1380, 200, 1},
      {"1a0d9cb1bbe.png", 800, -1000, 1},
      {"1a0d9cf58dc.png", 800, 200, 1},
    },
  }
  catalog["1059313160-43904-40"] = scene
  published["@7984879"] = scene
end

-- 4T-3-vivantes/spin-trampolines
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da1df99c.png", -1380, -1000, 1},
      {"1a0da1d9d60.png", -1380, 200, 1},
      {"1a0da1e6ed3.png", 600, -1000, 1},
      {"1a0da1a4a72.png", 600, 200, 1},
    },
  }
  catalog["3028665-24963-33"] = scene
  published["@7984880"] = scene
end

-- 4T-4-vivantes/the-floor-is-lava
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0f8b6a5aa.png", -1380, -1000, 1},
      {"1a0f8b6bd17.png", -1380, 200, 1},
      {"1a0f8b6d48c.png", 800, -1000, 1},
      {"1a0f8b6ec08.png", 800, 200, 1},
    },
  }
  catalog["1499850571-53211-44"] = scene
  published["@7985247"] = scene
end

-- 4T-3-vivantes/the-floor-is-lava
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0f8b647ea.png", -1380, -1000, 1},
      {"1a0f8b65f60.png", -1380, 200, 1},
      {"1a0f8b676c4.png", 600, -1000, 1},
      {"1a0f8b68e41.png", 600, 200, 1},
    },
  }
  catalog["1086810883-32255-36"] = scene
  published["@7985248"] = scene
end

-- 4T-2-vivantes/the-floor-is-lava
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0f8b5ed00.png", -1380, -1000, 1},
      {"1a0f8b60198.png", -1380, 200, 1},
      {"1a0f8b618f6.png", 400, -1000, 1},
      {"1a0f8b6307a.png", 400, 200, 1},
    },
  }
  catalog["969611748-13931-29"] = scene
  published["@7985245"] = scene
end

-- 4T-4-vivantes/choco-waters
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da0683dc.png", -1380, -1000, 1},
      {"1a0da08a6dc.png", -1380, 200, 1},
      {"1a0da0903e7.png", 800, -1000, 1},
      {"1a0da060e43.png", 800, 200, 1},
    },
  }
  catalog["1846317034-31705-36"] = scene
  published["@7984898"] = scene
end

-- 4T-3-vivantes/choco-waters
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da634d5d.png", -1380, -1000, 1},
      {"1a0da46b021.png", -1380, 200, 1},
      {"1a0da630705.png", 600, -1000, 1},
      {"1a0da460c03.png", 600, 200, 1},
    },
  }
  catalog["2131679833-16288-30"] = scene
  published["@7984899"] = scene
end

-- 4T-2-vivantes/choco-waters
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfe386ef.png", -1380, -1000, 1},
      {"1a0cfe2fa54.png", -1380, 200, 1},
      {"1a0cfe20fe1.png", 400, -1000, 1},
      {"1a0cfe1845e.png", 400, 200, 1},
    },
  }
  catalog["511231862-58082-21"] = scene
  published["@7984896"] = scene
end

-- 4T-4-vivantes/twin-trampolines
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9c9738a.png", -1380, -1000, 1},
      {"1a0d9c8fe4c.png", -1380, 200, 1},
      {"1a0d9ca002a.png", 800, -1000, 1},
      {"1a0d9ca8cd7.png", 800, 200, 1},
    },
  }
  catalog["691402623-63900-47"] = scene
  published["@7985227"] = scene
end

-- 4T-3-vivantes/twin-trampolines
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0d999a819.png", -1380, -1000, 1},
      {"1a0d9968cd3.png", -1380, 200, 1},
      {"1a0d9978c81.png", 600, -1000, 1},
      {"1a0da611f0c.png", 600, 200, 1},
    },
  }
  catalog["1458537000-50256-42"] = scene
  published["@7985228"] = scene
end

-- 4T-2-vivantes/twin-trampolines
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfa89dfb.png", -1380, -1000, 1},
      {"1a0cfa6d9e9.png", -1380, 200, 1},
      {"1a0cfab1652.png", 400, -1000, 1},
      {"1a0cfaa29dc.png", 400, 200, 1},
    },
  }
  catalog["996910509-36323-37"] = scene
  published["@7985229"] = scene
end

-- 4T-3-vivantes/black-pond
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da4cfc27.png", -1380, -1000, 1},
      {"1a0da4c49e2.png", -1380, 200, 1},
      {"1a0d9c16bdb.png", 600, -1000, 1},
      {"1a0da4c9e63.png", 600, 200, 1},
    },
  }
  catalog["1122741249-15945-30"] = scene
  published["@7984911"] = scene
end

-- 4T-2-vivantes/black-pond
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfe3cd4f.png", -1380, -1000, 1},
      {"1a0d996a251.png", -1380, 200, 1},
      {"1a0d9972ebb.png", 400, -1000, 1},
      {"1a0cfe459f2.png", 400, 200, 1},
    },
  }
  catalog["958423611-58125-21"] = scene
  published["@7984908"] = scene
end

-- 4T-4-vivantes/no-jump
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9d1d3f1.png", -1380, -1000, 1},
      {"1a0d9d0a2a7.png", -1380, 200, 1},
      {"1a0d9d27ac5.png", 800, -1000, 1},
      {"1a0d9d117d6.png", 800, 200, 1},
    },
  }
  catalog["871101487-11952-28"] = scene
  published["@7984855"] = scene
end

-- 4T-3-vivantes/no-jump
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da324dfb.png", -1380, -1000, 1},
      {"1a0da620a84.png", -1380, 200, 1},
      {"1a0da31bec5.png", 600, -1000, 1},
      {"1a0da62396e.png", 600, 200, 1},
    },
  }
  catalog["1189449156-3744-25"] = scene
  published["@7984856"] = scene
end

-- 4T-2-vivantes/no-jump
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfae3593.png", -1380, -1000, 1},
      {"1a0cfada775.png", -1380, 200, 1},
      {"1a0cfaeaac2.png", 400, -1000, 1},
      {"1a0cfad3243.png", 400, 200, 1},
    },
  }
  catalog["795542110-53313-19"] = scene
  published["@7984853"] = scene
end

-- 4T-3-vivantes/honeymoon
do
  local scene = {
    hideBorders=true,
    width=1200, height=400,
    pieces={
      {"1a0da3ded98.png", -1380, -1000, 1},
      {"1a0da39ec5b.png", -1380, 200, 1},
      {"1a0da3d60ee.png", 600, -1000, 1},
      {"1a0da3cd4f3.png", 600, 200, 1},
    },
  }
  catalog["1023816945-42085-40"] = scene
  published["@7984907"] = scene
end

-- 4T-2-vivantes/honeymoon
do
  local scene = {
    hideBorders=true,
    width=800, height=400,
    pieces={
      {"1a0cfc1be17.png", -1380, -1000, 1},
      {"1a0cfbfba2e.png", -1380, 200, 1},
      {"1a0cfc046da.png", 400, -1000, 1},
      {"1a0cfc13188.png", 400, 200, 1},
    },
  }
  catalog["1224312110-23038-33"] = scene
  published["@7984904"] = scene
end

-- 4T-4-vivantes/collision
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da08ec7c.png", -1380, -1000, 1},
      {"1a0da066c79.png", -1380, 200, 1},
      {"1a0da05b080.png", 800, -1000, 1},
      {"1a0da059916.png", 800, 200, 1},
    },
  }
  catalog["1347981057-24025-33"] = scene
  published["@7984859"] = scene
end

-- 4T-3-vivantes/collision
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da3f64af.png", -1380, -1000, 1},
      {"1a0da4698b2.png", -1380, 200, 1},
      {"1a0da459713.png", 600, -1000, 1},
      {"1a0da3ff1b0.png", 600, 200, 1},
    },
  }
  catalog["1016435664-7889-27"] = scene
  published["@7984860"] = scene
end

-- 4T-2-vivantes/collision
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfe1f87c.png", -1380, -1000, 1},
      {"1a0cfc264f9.png", -1380, 200, 1},
      {"1a0cfe2851d.png", 400, -1000, 1},
      {"1a0cfe36f7e.png", 400, 200, 1},
    },
  }
  catalog["1887650777-65058-24"] = scene
  published["@7984857"] = scene
end

-- 4T-4-vivantes/snowy-mountains
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9cfa0be.png", -1380, -1000, 1},
      {"1a0d9cefb14.png", -1380, 200, 1},
      {"1a0d9cf1295.png", 800, -1000, 1},
      {"1a0d9d015ff.png", 800, 200, 1},
    },
  }
  catalog["119963061-30534-61"] = scene
  published["@7984920"] = scene
end

-- 4T-3-vivantes/snowy-mountains
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da61655f.png", -1380, -1000, 1},
      {"1a0da61c657.png", -1380, 200, 1},
      {"1a0da617cd3.png", 600, -1000, 1},
      {"1a0da613679.png", 600, 200, 1},
    },
  }
  catalog["903368474-7303-52"] = scene
  published["@7984921"] = scene
  catalog["1146830841-7243-52"] = scene
  published["@7985747"] = scene
end

-- 4T-2-vivantes/snowy-mountains
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da604c0f.png", -1380, -1000, 1},
      {"1a0da607af0.png", -1380, 200, 1},
      {"1a0cfab7417.png", 400, -1000, 1},
      {"1a0da601d29.png", 400, 200, 1},
    },
  }
  catalog["1537626368-41603-40"] = scene
  published["@7984918"] = scene
end

-- 4T-4-vivantes/halloween
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9d5f59d.png", -1380, -1000, 1},
      {"1a0da04396b.png", -1380, 200, 1},
      {"1a0da03db9c.png", 800, -1000, 1},
      {"1a0da03662a.png", 800, 200, 1},
    },
  }
  catalog["1350155980-24112-33"] = scene
  published["@7985206"] = scene
end

-- 4T-3-vivantes/halloween
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0d9bdea0a.png", -1380, -1000, 1},
      {"1a0d9bd592c.png", -1380, 200, 1},
      {"1a0d9bc6eae.png", 600, -1000, 1},
      {"1a0d9bce3eb.png", 600, 200, 1},
    },
  }
  catalog["1300850221-13470-29"] = scene
  published["@7985207"] = scene
  catalog["1126888717-13410-29"] = scene
  published["@7985703"] = scene
end

-- 4T-2-vivantes/halloween
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfc1604d.png", -1380, -1000, 1},
      {"1a0cfc05e46.png", -1380, 200, 1},
      {"1a0cfbfe919.png", 400, -1000, 1},
      {"1a0cfc0ed69.png", 400, 200, 1},
    },
  }
  catalog["1840287158-64752-24"] = scene
  published["@7985208"] = scene
  catalog["319101049-64692-24"] = scene
  published["@7985704"] = scene
end

-- 4T-4-vivantes/spooky-no-jump
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9caee4d.png", -1380, -1000, 1},
      {"1a0d9cfe70f.png", -1380, 200, 1},
      {"1a0d9ce4085.png", -290, 200, 1},
      {"1a0d9ca5df0.png", 800, -1000, 1},
      {"1a0d9cecc26.png", 800, 200, 1},
      {"1a0d9cb044f.png", 1890, 200, 1},
    },
  }
  catalog["1903731991-9313-27"] = scene
  published["@7985221"] = scene
  catalog["1114293743-9253-27"] = scene
  published["@7985748"] = scene
end

-- 4T-3-vivantes/spooky-no-jump
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0d99a05db.png", -1380, -1000, 1},
      {"1a0d99978dd.png", -1380, 200, 1},
      {"1a0d997ea49.png", 600, -1000, 1},
      {"1a0d998ec4a.png", 600, 200, 1},
    },
  }
  catalog["121079253-64048-23"] = scene
  published["@7985222"] = scene
  catalog["626352872-63988-23"] = scene
  published["@7985749"] = scene
end

-- 4T-2-vivantes/spooky-no-jump
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da5f6310.png", -1380, -1000, 1},
      {"1a0da5fa7f3.png", -1380, 200, 1},
      {"1a0da5fd6d2.png", 400, -1000, 1},
      {"1a0da5ef267.png", 400, 200, 1},
    },
  }
  catalog["825754486-53026-19"] = scene
  published["@7985223"] = scene
  catalog["440302046-52966-19"] = scene
  published["@7985750"] = scene
end

-- 4T-4-vivantes/eclipse
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da037d90.png", -1380, -1000, 1},
      {"1a0da04aea4.png", -1380, 200, 1},
      {"1a0d9d60d0a.png", 800, -1000, 1},
      {"1a0da0450dd.png", 800, 200, 1},
    },
  }
  catalog["185798889-27811-58"] = scene
  published["@7985265"] = scene
end

-- 4T-3-vivantes/eclipse
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da462373.png", -1380, -1000, 1},
      {"1a0da3dd628.png", -1380, 200, 1},
      {"1a0da3e62cd.png", 600, -1000, 1},
      {"1a0da62ef98.png", 600, 200, 1},
    },
  }
  catalog["746451074-63130-47"] = scene
  published["@7985266"] = scene
end

-- 4T-2-vivantes/eclipse
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfc177bc.png", -1380, -1000, 1},
      {"1a0cfc1efbb.png", -1380, 200, 1},
      {"1a0cfc10284.png", 400, -1000, 1},
      {"1a0cfc075c4.png", 400, 200, 1},
    },
  }
  catalog["875528437-44205-40"] = scene
  published["@7985263"] = scene
end

-- 4T-4-vivantes/tube-cannon
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9c8a085.png", -1380, -1000, 1},
      {"1a0d9ca179a.png", -1380, 200, 1},
      {"1a0d9c915ba.png", 800, -1000, 1},
      {"1a0d9c98af0.png", 800, 200, 1},
    },
  }
  catalog["981421898-508-50"] = scene
  published["@7985224"] = scene
  catalog["950609513-448-50"] = scene
  published["@7985751"] = scene
end

-- 4T-3-vivantes/tube-cannon
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0d9993282.png", -1380, -1000, 1},
      {"1a0d998a5d4.png", -1380, 200, 1},
      {"1a0d999bf85.png", 600, -1000, 1},
      {"1a0d998192b.png", 600, 200, 1},
    },
  }
  catalog["99676748-33139-37"] = scene
  published["@7985225"] = scene
end

-- 4T-2-vivantes/tube-cannon
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfa96e4f.png", -1380, -1000, 1},
      {"1a0cfa8b2c2.png", -1380, 200, 1},
      {"1a0cfa6f159.png", 400, -1000, 1},
      {"1a0cfaa4143.png", 400, 200, 1},
    },
  }
  catalog["1353436214-9908-28"] = scene
  published["@7985226"] = scene
  catalog["1462627473-9848-28"] = scene
  published["@7985752"] = scene
end

-- 4T-4-vivantes/ice-collision
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9d4506c.png", -1380, -1000, 1},
      {"1a0d9d40955.png", -1380, 200, 1},
      {"1a0d9d46718.png", -290, 200, 1},
      {"1a0d9d33651.png", 800, -1000, 1},
      {"1a0d9d3ab8b.png", 800, 200, 1},
      {"1a0d9d4c4db.png", 1890, 200, 1},
    },
  }
  catalog["66564796-6556-26"] = scene
  published["@7984934"] = scene
end

-- 4T-3-vivantes/ice-collision
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da38a430.png", -1380, -1000, 1},
      {"1a0da6250d0.png", -1380, 200, 1},
      {"1a0da62d826.png", -390, 200, 1},
      {"1a0da37736f.png", 600, -1000, 1},
      {"1a0da62c0b4.png", 600, 200, 1},
      {"1a0da37e8a3.png", 1590, 200, 1},
    },
  }
  catalog["703387704-61332-22"] = scene
  published["@7984935"] = scene
end

-- 4T-2-vivantes/ice-collision
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfbf5c76.png", -1380, -1000, 1},
      {"1a0cfb01f35.png", -1380, 200, 1},
      {"1a0cfbed127.png", -490, 200, 1},
      {"1a0cfb0abd9.png", 400, -1000, 1},
      {"1a0cfaf1ffc.png", 400, 200, 1},
      {"1a0cfbf73db.png", 1290, 200, 1},
    },
  }
  catalog["1822746474-53285-19"] = scene
  published["@7984932"] = scene
  catalog["347962187-53225-19"] = scene
  published["@7985712"] = scene
end

-- 4T-4-vivantes/ice-booster
do
  local scene = {
    hideBorders=true,
    width=1600, height=400,
    pieces={
      {"1a0d9d34dc8.png", -1380, -1000, 1},
      {"1a0d9d47e88.png", -1380, 200, 1},
      {"1a0d9d3c2fb.png", -290, 200, 1},
      {"1a0d9d36539.png", 800, -1000, 1},
      {"1a0d9d4dc4d.png", 800, 200, 1},
      {"1a0d9d420c3.png", 1890, 200, 1},
    },
  }
  catalog["265867957-54335-42"] = scene
  published["@7984944"] = scene
  catalog["1139607387-54275-42"] = scene
  published["@7985710"] = scene
end

-- 4T-3-vivantes/ice-booster
do
  local scene = {
    hideBorders=true,
    width=1200, height=400,
    pieces={
      {"1a0da398e8e.png", -1380, -1000, 1},
      {"1a0da3930d0.png", -1380, 200, 1},
      {"1a0da39c068.png", -390, 200, 1},
      {"1a0da378adb.png", 600, -1000, 1},
      {"1a0da394841.png", 600, 200, 1},
      {"1a0da395fa6.png", 1590, 200, 1},
    },
  }
  catalog["943467518-34411-35"] = scene
  published["@7984945"] = scene
  catalog["1702147513-34351-35"] = scene
  published["@7985711"] = scene
end

-- 4T-2-vivantes/ice-booster
do
  local scene = {
    hideBorders=true,
    width=800, height=400,
    pieces={
      {"1a0cfb0c348.png", -1380, -1000, 1},
      {"1a0cfb0369d.png", -1380, 200, 1},
      {"1a0cfc18f32.png", -490, 200, 1},
      {"1a0cfbee750.png", 400, -1000, 1},
      {"1a0da609260.png", 400, 200, 1},
      {"1a0cfbf8b50.png", 1290, 200, 1},
    },
  }
  catalog["48666429-20590-30"] = scene
  published["@7984942"] = scene
  catalog["860128120-20530-30"] = scene
  published["@7985708"] = scene
end

-- 4T-3-vivantes/light-dark
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da30bcde.png", -1380, -1000, 1},
      {"1a0da31321d.png", -1380, 200, 1},
      {"1a0da326561.png", 600, -1000, 1},
      {"1a0da36e6c6.png", 600, 200, 1},
    },
  }
  catalog["1363039590-65305-46"] = scene
  published["@7984949"] = scene
  catalog["1419898323-65245-46"] = scene
  published["@7985734"] = scene
end

-- 4T-2-vivantes/light-dark
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfaf3770.png", -1380, -1000, 1},
      {"1a0cfb04f66.png", -1380, 200, 1},
      {"1a0cfb0dabb.png", 400, -1000, 1},
      {"1a0cfbefea4.png", 400, 200, 1},
    },
  }
  catalog["628568408-39818-37"] = scene
  published["@7984946"] = scene
  catalog["1833869786-39758-37"] = scene
  published["@7985731"] = scene
end

-- 4T-4-vivantes/volley-2-0
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da6393b1.png", -1380, -1000, 1},
      {"1a0d9c88909.png", -1380, 200, 1},
      {"1a0d9ca7563.png", 800, -1000, 1},
      {"1a0da63ab1e.png", 800, 200, 1},
    },
  }
  catalog["1531039119-33629-36"] = scene
  published["@7984955"] = scene
  catalog["118937509-33569-36"] = scene
  published["@7985754"] = scene
end

-- 4T-3-vivantes/volley-2-0
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da18ead4.png", -1380, -1000, 1},
      {"1a0da17ba0c.png", -1380, 200, 1},
      {"1a0da188d06.png", 600, -1000, 1},
      {"1a0da182f3e.png", 600, 200, 1},
    },
  }
  catalog["1610133592-12440-28"] = scene
  published["@7984956"] = scene
end

-- 4T-2-vivantes/volley-2-0
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfaa1269.png", -1380, -1000, 1},
      {"1a0cfaafedc.png", -1380, 200, 1},
      {"1a0cfa77e05.png", 400, -1000, 1},
      {"1a0cfa956ed.png", 400, 200, 1},
    },
  }
  catalog["1894748033-61372-22"] = scene
  published["@7984953"] = scene
end

-- 4T-4-vivantes/pink-date
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da6437cf.png", -1380, -1000, 1},
      {"1a0da6408e6.png", -1380, 200, 1},
      {"1a0da63f173.png", 800, -1000, 1},
      {"1a0da63da07.png", 800, 200, 1},
      {"1a0d9d2c109.png", 334, 112, 1, layer="!1000"},
      {"1a0d9d2c109.png", 734, 112, 1, layer="!1000"},
      {"1a0d9d2c109.png", 1134, 112, 1, layer="!1000"},
    },
  }
  catalog["1826231665-52288-44"] = scene
  published["@7984972"] = scene
  catalog["1470174632-52228-44"] = scene
  published["@7985740"] = scene
end

-- 4T-3-vivantes/pink-date
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da2f8c29.png", -1380, -1000, 1},
      {"1a0da30015c.png", -1380, 200, 1},
      {"1a0da320787.png", 600, -1000, 1},
      {"1a0da3047b1.png", 600, 200, 1},
      {"1a0d9d2c109.png", 334, 112, 1, layer="!1000"},
      {"1a0d9d2c109.png", 734, 112, 1, layer="!1000"},
    },
  }
  catalog["461852483-28897-35"] = scene
  published["@7984973"] = scene
  catalog["1723483403-28837-35"] = scene
  published["@7985741"] = scene
end

-- 4T-2-vivantes/pink-date
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfabc373.png", -1380, -1000, 1},
      {"1a0cfad035f.png", -1380, 200, 1},
      {"1a0cfae053c.png", 400, -1000, 1},
      {"1a0cfabd86c.png", 400, 200, 1},
      {"1a0da329437.png", 323, 106, 1, layer="!1000"},
    },
  }
  catalog["1589179725-5173-26"] = scene
  published["@7984970"] = scene
  catalog["2136584251-5113-26"] = scene
  published["@7985739"] = scene
end

-- 4T-4-vivantes/kralizmox
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9d29237.png", -1380, -1000, 1},
      {"1a0d9d3076e.png", -1380, 200, 1},
      {"1a0d9d0d186.png", -290, 200, 1},
      {"1a0d9d12f55.png", 800, -1000, 1},
      {"1a0d9d1a47a.png", 800, 200, 1},
      {"1a0d9d14943.png", 1890, 200, 1},
    },
  }
  catalog["1935028562-15846-29"] = scene
  published["@7985261"] = scene
  catalog["1502437371-15736-29"] = scene
  published["@7985722"] = scene
end

-- 4T-3-vivantes/kralizmox
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da380017.png", -1380, -1000, 1},
      {"1a0da385de1.png", -1380, 200, 1},
      {"1a0da37a245.png", 600, -1000, 1},
      {"1a0da374486.png", 600, 200, 1},
      {"1a0da38ea7d.png", 1590, 200, 1},
    },
  }
  catalog["1550811378-4572-25"] = scene
  published["@7985262"] = scene
  catalog["1706917923-4462-25"] = scene
  published["@7985723"] = scene
end

-- 4T-2-vivantes/kralizmox
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfb07cf6.png", -1380, -1000, 1},
      {"1a0cfaed9ae.png", -1380, 200, 1},
      {"1a0cfbf2d8e.png", 400, -1000, 1},
      {"1a0cfaf4ee7.png", 400, 200, 1},
    },
  }
  catalog["961490928-61509-22"] = scene
  published["@7985259"] = scene
  catalog["1292876676-61399-22"] = scene
  published["@7985720"] = scene
end

-- 4T-4-vivantes/the-rainbow
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9c9b9d4.png", -1380, -1000, 1},
      {"1a0d9c9449c.png", -1380, 200, 1},
      {"1a0d9cad324.png", 800, -1000, 1},
      {"1a0d9c8cf60.png", 800, 200, 1},
    },
  }
  catalog["45162040-19306-77"] = scene
  published["@7984977"] = scene
end

-- 4T-3-vivantes/the-rainbow
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da19a657.png", -1380, -1000, 1},
      {"1a0d9984811.png", -1380, 200, 1},
      {"1a0da1a340e.png", 600, -1000, 1},
      {"1a0d998d4bc.png", 600, 200, 1},
    },
  }
  catalog["77715627-38410-60"] = scene
  published["@7984978"] = scene
end

-- 4T-2-vivantes/the-rainbow
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfa72038.png", -1380, -1000, 1},
      {"1a0cfa8ca2e.png", -1380, 200, 1},
      {"1a0cfab452a.png", 400, -1000, 1},
      {"1a0cfa99d33.png", 400, 200, 1},
    },
  }
  catalog["674080404-61395-45"] = scene
  published["@7984974"] = scene
end

-- 4T-4-vivantes/platforms
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da642059.png", -1380, -1000, 1},
      {"1a0da63c294.png", 800, -1000, 1},
    },
  }
  catalog["1831244232-61344-74"] = scene
  published["@7984981"] = scene
  published["@7985274"] = scene
  published["@7985278"] = scene
end

-- 4T-3-vivantes/platforms
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da2fbb0b.png", -1380, -1000, 1},
      {"1a0da2f45d7.png", 600, -1000, 1},
    },
  }
  catalog["1912369198-19949-58"] = scene
  published["@7984982"] = scene
  published["@7985275"] = scene
end

-- 4T-2-vivantes/platforms
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfae7be5.png", -1380, -1000, 1},
      {"1a0cfad7888.png", 400, -1000, 1},
    },
  }
  catalog["1960478565-49471-44"] = scene
  published["@7984979"] = scene
  published["@7985272"] = scene
end

-- 4T-4-vivantes/some-chords
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9ce6e5e.png", -1380, -1000, 1},
      {"1a0d9cb332d.png", -290, -1000, 1},
      {"1a0d9cffe88.png", -1380, 200, 1},
      {"1a0d9cf8b06.png", 800, -1000, 1},
      {"1a0d9cee395.png", 800, 200, 1},
    },
  }
  catalog["1910961868-17324-29"] = scene
  published["@7984985"] = scene
end

-- 4T-3-vivantes/some-chords
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da1e112c.png", -1380, -1000, 1},
      {"1a0da619441.png", -1380, 200, 1},
      {"1a0da1db34d.png", 600, -1000, 1},
      {"1a0da1a61e8.png", 600, 200, 1},
    },
  }
  catalog["1375202986-5802-25"] = scene
  published["@7984986"] = scene
end

-- 4T-2-vivantes/some-chords
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da606394.png", -1380, -1000, 1},
      {"1a0da5fee4f.png", -1380, 200, 1},
      {"1a0da6005bd.png", 400, -1000, 1},
      {"1a0da6034a9.png", 400, 200, 1},
    },
  }
  catalog["1997224107-59875-21"] = scene
  published["@7984983"] = scene
end

-- 4T-3-vivantes/quad-cannons
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da2f175c.png", -1380, -1000, 1},
      {"1a0da2fa392.png", -1380, 200, 1},
      {"1a0da2f2e59.png", -390, 200, 1},
      {"1a0da2116af.png", 600, -1000, 1},
      {"1a0da2f5d3b.png", 600, 200, 1},
      {"1a0da3018c9.png", 1590, 200, 1},
    },
  }
  catalog["1289164141-42145-42"] = scene
  published["@7985008"] = scene
end

-- 4T-2-vivantes/quad-cannons
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfadedc0.png", -1380, -1000, 1},
      {"1a0cfaba608.png", -1380, 200, 1},
      {"1a0cfac362d.png", 400, -1000, 1},
      {"1a0cfad6125.png", 400, 200, 1},
    },
  }
  catalog["1418215341-33635-39"] = scene
  published["@7985005"] = scene
end

-- 4T-4-vivantes/default-map
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da056a3f.png", -1380, -1000, 1},
      {"1a0da053b4b.png", -1380, 200, 1},
      {"1a0da0523d2.png", 800, -1000, 1},
      {"1a0da050c6d.png", 800, 200, 1},
    },
  }
  catalog["919598699-28963-34"] = scene
  published["@7985199"] = scene
  catalog["1580846165-28903-34"] = scene
  published["@7985695"] = scene
end

-- 4T-3-vivantes/default-map
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da3f06eb.png", -1380, -1000, 1},
      {"1a0da463ae6.png", -1380, 200, 1},
      {"1a0da40208f.png", 600, -1000, 1},
      {"1a0da3f9394.png", 600, 200, 1},
    },
  }
  catalog["833579328-15288-29"] = scene
  published["@7985200"] = scene
  catalog["1189620073-15228-29"] = scene
  published["@7985696"] = scene
end

-- 4T-2-vivantes/default-map
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfe2cb72.png", -1380, -1000, 1},
      {"1a0cfe2563d.png", -1380, 200, 1},
      {"1a0cfc24d79.png", 400, -1000, 1},
      {"1a0cfe1c995.png", 400, 200, 1},
    },
  }
  catalog["910414154-55942-20"] = scene
  published["@7984815"] = scene
end

-- 4T-4-vivantes/impostor
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9d43839.png", -1380, -1000, 1},
      {"1a0d9d2ab07.png", -1380, 200, 1},
      {"1a0d9d495f9.png", 800, -1000, 1},
      {"1a0d9d3da72.png", 800, 200, 1},
    },
  }
  catalog["1072698299-41822-40"] = scene
  published["@7985025"] = scene
  catalog["1225132644-41762-40"] = scene
  published["@7985718"] = scene
end

-- 4T-3-vivantes/impostor
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da3901ee.png", -1380, -1000, 1},
      {"1a0da375bf5.png", -1380, 200, 1},
      {"1a0da37d135.png", 600, -1000, 1},
      {"1a0da382efb.png", 600, 200, 1},
    },
  }
  catalog["1638070039-21137-32"] = scene
  published["@7985026"] = scene
  catalog["49834937-21077-32"] = scene
  published["@7985719"] = scene
end

-- 4T-2-vivantes/impostor
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfbf44ff.png", -1380, -1000, 1},
      {"1a0cfaef11e.png", -1380, 200, 1},
      {"1a0cfb109a7.png", 400, -1000, 1},
      {"1a0cfaf6655.png", 400, 200, 1},
    },
  }
  catalog["1704795425-5839-26"] = scene
  published["@7985023"] = scene
  catalog["1934195952-5779-26"] = scene
  published["@7985716"] = scene
end

-- 4T-4-vivantes/ocean
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9d073bb.png", -1380, -1000, 1},
      {"1a0d9d1005f.png", -1380, 200, 1},
      {"1a0d9d2d888.png", -290, 200, 1},
      {"1a0d9d0e8f1.png", 800, -1000, 1},
      {"1a0d9d08b2f.png", 800, 200, 1},
      {"1a0d9d17599.png", 1890, 200, 1},
    },
  }
  catalog["1527176577-11680-28"] = scene
  published["@7985036"] = scene
  catalog["25727508-11620-28"] = scene
  published["@7985737"] = scene
end

-- 4T-3-vivantes/ocean
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da305f1b.png", -1380, -1000, 1},
      {"1a0da317870.png", -1380, 200, 1},
      {"1a0da30ebc7.png", -390, 200, 1},
      {"1a0da307687.png", 600, -1000, 1},
      {"1a0da318fd6.png", 600, 200, 1},
      {"1a0da6221ec.png", 1590, 200, 1},
    },
  }
  catalog["1077430992-681-24"] = scene
  published["@7985037"] = scene
  catalog["1496907046-621-24"] = scene
  published["@7985738"] = scene
end

-- 4T-2-vivantes/ocean
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfad1acc.png", -1380, -1000, 1},
      {"1a0cfae1d46.png", -1380, 200, 1},
      {"1a0cfabefd8.png", 400, -1000, 1},
      {"1a0cfad9006.png", 400, 200, 1},
    },
  }
  catalog["1096865655-58884-21"] = scene
  published["@7985034"] = scene
  catalog["1492849711-58824-21"] = scene
  published["@7985735"] = scene
end

-- 4T-4-vivantes/dusty-journey
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da046843.png", -1380, -1000, 1},
      {"1a0da03f31a.png", -1380, 200, 1},
      {"1a0da039503.png", 800, -1000, 1},
      {"1a0da04c615.png", 800, 200, 1},
    },
  }
  catalog["1587188712-8732-48"] = scene
  published["@7985076"] = scene
end

-- 4T-3-vivantes/dusty-journey
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0d9bfdcb5.png", -1380, -1000, 1},
      {"1a0d9be73e1.png", -1380, 200, 1},
      {"1a0d9bf5003.png", 600, -1000, 1},
      {"1a0d9be0043.png", 600, 200, 1},
    },
  }
  catalog["2017524639-41915-38"] = scene
  published["@7985077"] = scene
  catalog["233082460-41855-38"] = scene
  published["@7985701"] = scene
end

-- 4T-2-vivantes/dusty-journey
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da60c14f.png", -1380, -1000, 1},
      {"1a0cfc08d2d.png", -1380, 200, 1},
      {"1a0cfc20732.png", 400, -1000, 1},
      {"1a0cfc0008b.png", 400, 200, 1},
    },
  }
  catalog["1251134541-30818-34"] = scene
  published["@7985078"] = scene
  catalog["995439254-30758-34"] = scene
  published["@7985702"] = scene
end

-- 4T-4-vivantes/departure
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da0421ed.png", -1380, -1000, 1},
      {"1a0da04f4fa.png", -1380, 200, 1},
      {"1a0da033746.png", 800, -1000, 1},
      {"1a0da0552bb.png", 800, 200, 1},
    },
  }
  catalog["1148044508-23278-56"] = scene
  published["@7985066"] = scene
end

-- 4T-3-vivantes/departure
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0d9bff425.png", -1380, -1000, 1},
      {"1a0d9be2d8e.png", -1380, 200, 1},
      {"1a0d9c080d5.png", 600, -1000, 1},
      {"1a0d9bedad3.png", 600, 200, 1},
    },
  }
  catalog["41367870-34427-57"] = scene
  published["@7985068"] = scene
  catalog["1767026455-34367-57"] = scene
  published["@7985697"] = scene
end

-- 4T-2-vivantes/departure
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfe23ecb.png", -1380, -1000, 1},
      {"1a0cfe3409d.png", -1380, 200, 1},
      {"1a0cfe2b400.png", 400, -1000, 1},
      {"1a0cfc2360d.png", 400, 200, 1},
    },
  }
  catalog["420110573-34559-56"] = scene
  published["@7985069"] = scene
  catalog["463209164-34499-56"] = scene
  published["@7985698"] = scene
end

-- 4T-4-vivantes/simple-neon
do
  local scene = {
    hideBorders=true,
    width=1600, height=400,
    pieces={
      {"1a0cfa4699a.png", -1380, -1000, 1},
      {"1a0cfa48103.png", -1380, 200, 1},
      {"1a0cfa49880.png", 800, -1000, 1},
      {"1a0cfa4afea.png", 800, 200, 1},
    },
  }
  catalog["1173766353-12112-50"] = scene
  published["@7985079"] = scene
end

-- 4T-3-vivantes/simple-neon
do
  local scene = {
    hideBorders=true,
    width=1200, height=400,
    pieces={
      {"1a0cfa40bda.png", -1380, -1000, 1},
      {"1a0cfa42349.png", -1380, 200, 1},
      {"1a0cfa43abf.png", 600, -1000, 1},
      {"1a0cfa4522b.png", 600, 200, 1},
    },
  }
  catalog["140145077-57552-43"] = scene
  published["@7985080"] = scene
end

-- 4T-2-vivantes/simple-neon
do
  local scene = {
    hideBorders=true,
    width=800, height=400,
    pieces={
      {"1a0cfa3dcff.png", -1380, -1000, 1},
      {"1a0cfa3f466.png", 400, -1000, 1},
    },
  }
  catalog["600319957-37260-36"] = scene
  published["@7985081"] = scene
end

-- 4T-4-vivantes/dragon-water
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da04dd86.png", -1380, -1000, 1},
      {"1a0da03ac7b.png", -1380, 200, 1},
      {"1a0da047fb7.png", -290, 200, 1},
      {"1a0da040a7e.png", 800, -1000, 1},
      {"1a0da0320dc.png", 800, 200, 1},
    },
  }
  catalog["1561675655-39058-38"] = scene
  published["@7985203"] = scene
  catalog["844335126-38998-38"] = scene
  published["@7985699"] = scene
end

-- 4T-3-vivantes/dragon-water
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0d9bec36a.png", -1380, -1000, 1},
      {"1a0d9be1620.png", -1380, 200, 1},
      {"1a0d9bf677a.png", 600, -1000, 1},
      {"1a0d9c06968.png", 600, 200, 1},
    },
  }
  catalog["963275648-11394-28"] = scene
  published["@7985204"] = scene
  catalog["1878781212-11334-28"] = scene
  published["@7985700"] = scene
end

-- 4T-2-vivantes/dragon-water
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfe3292b.png", -1380, -1000, 1},
      {"1a0da60d8b7.png", -1380, 200, 1},
      {"1a0cfe1b21f.png", 400, -1000, 1},
      {"1a0cfc21ea3.png", 400, 200, 1},
    },
  }
  catalog["354914538-62695-23"] = scene
  published["@7985205"] = scene
end

-- 4T-4-vivantes/cherry-blossom
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da069b52.png", -1380, -1000, 1},
      {"1a0da091b53.png", -290, -1000, 1},
      {"1a0da062770.png", -1380, 200, 1},
      {"1a0da08bd9b.png", 800, -1000, 1},
      {"1a0da05c7fa.png", 800, 200, 1},
      {"1a0f839747c.png", 367.7314211212516, 249.02216427640155, 0.0651890482398957},
      {"1a0f839747c.png", 767.7314211212516, 249.02216427640155, 0.0651890482398957},
      {"1a0f839747c.png", 1167.7314211212515, 249.02216427640155, 0.0651890482398957},
    },
  }
  catalog["1290976541-39740-39"] = scene
  published["@7985196"] = scene
  catalog["204127888-39680-39"] = scene
  published["@7985691"] = scene
end

-- 4T-3-vivantes/cherry-blossom
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da6335f7.png", -1380, -1000, 1},
      {"1a0da637c42.png", -1380, 200, 1},
      {"1a0da631e7a.png", 600, -1000, 1},
      {"1a0da6364cf.png", 600, 200, 1},
    },
  }
  catalog["313291704-5628-26"] = scene
end

-- 4T-2-vivantes/cherry-blossom
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfe19b6a.png", -1380, -1000, 1},
      {"1a0cfe311cc.png", -1380, 200, 1},
      {"1a0cfe39e5d.png", 400, -1000, 1},
      {"1a0cfe29c95.png", 400, 200, 1},
      {"1a0f839747c.png", 367.7314211212516, 250.02216427640155, 0.0651890482398957},
    },
  }
  catalog["1818935705-57608-21"] = scene
  published["@7985198"] = scene
end

-- 4T-4-vivantes/yin-yang
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9c85a33.png", -1380, -1000, 1},
      {"1a0d9c1f889.png", -1380, 200, 1},
      {"1a0d9c10d84.png", 800, -1000, 1},
      {"1a0d9c7e649.png", 800, 200, 1},
    },
  }
  catalog["1988855872-39799-60"] = scene
  published["@7985094"] = scene
  catalog["1946423146-39739-60"] = scene
  published["@7985755"] = scene
end

-- 4T-3-vivantes/yin-yang
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0cfe4715f.png", -1380, -1000, 1},
      {"1a0d996d0fe.png", -1380, 200, 1},
      {"1a0cfe4e755.png", 600, -1000, 1},
      {"1a0cfe3fc36.png", 600, 200, 1},
    },
  }
  catalog["240200155-30989-57"] = scene
  published["@7985095"] = scene
  catalog["1897691905-30929-57"] = scene
  published["@7985756"] = scene
end

-- 4T-2-vivantes/yin-yang
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfa68f80.png", -1380, -1000, 1},
      {"1a0cfaad071.png", -1380, 200, 1},
      {"1a0cfa674df.png", 400, -1000, 1},
      {"1a0cfa927f8.png", 400, 200, 1},
    },
  }
  catalog["1680660502-41790-38"] = scene
  published["@7985096"] = scene
end

-- 4T-4-vivantes/ice-wheel
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9d394c2.png", -1380, -1000, 1},
      {"1a0d9d3f1dc.png", -1380, 200, 1},
      {"1a0d9d31ee3.png", 800, -1000, 1},
      {"1a0d9d4ad65.png", 800, 200, 1},
    },
  }
  catalog["1288090053-6033-52"] = scene
  published["@7985097"] = scene
  catalog["974401590-5973-52"] = scene
  published["@7985714"] = scene
end

-- 4T-3-vivantes/ice-wheel
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0d9af487d.png", -1380, -1000, 1},
      {"1a0d9afbdb6.png", -1380, 200, 1},
      {"1a0d9bb54dc.png", 600, -1000, 1},
      {"1a0d9baf741.png", 600, 200, 1},
    },
  }
  catalog["1319047903-40208-40"] = scene
  published["@7985098"] = scene
  catalog["1404601758-40148-40"] = scene
  published["@7985715"] = scene
end

-- 4T-2-vivantes/ice-wheel
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfb12111.png", -1380, -1000, 1},
      {"1a0cfaf0886.png", -1380, 200, 1},
      {"1a0cfb09648.png", 400, -1000, 1},
      {"1a0cfb00b97.png", 400, 200, 1},
    },
  }
  catalog["1610576830-17161-31"] = scene
  published["@7985099"] = scene
end

-- 4T-4-vivantes/sabiro-fishes
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0cfaaa331.png", -1380, -1000, 1},
      {"1a0cfa9e384.png", -1380, 200, 1},
      {"1a0cfaab889.png", -290, 200, 1},
      {"1a0cfa65d70.png", 800, -1000, 1},
      {"1a0cfa74f1c.png", 800, 200, 1},
      {"1a0cfa91084.png", 1890, 200, 1},
    },
  }
  catalog["1830686295-54297-43"] = scene
  published["@7985216"] = scene
  catalog["1945474209-54237-43"] = scene
  published["@7985742"] = scene
end

-- 4T-3-vivantes/sabiro-fishes
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da5ec380.png", -1380, -1000, 1},
      {"1a0cfa8f916.png", -1380, 200, 1},
      {"1a0cfa9cc12.png", -390, 200, 1},
      {"1a0da5edaf5.png", 600, -1000, 1},
      {"1a0cfa737ac.png", 600, 200, 1},
      {"1a0cfaa879f.png", 1590, 200, 1},
    },
  }
  catalog["906250125-29265-34"] = scene
  published["@7985217"] = scene
  catalog["474086449-29205-34"] = scene
  published["@7985743"] = scene
end

-- 4T-2-vivantes/sabiro-fishes
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfa582f0.png", -1380, -1000, 1},
      {"1a0cfa59aad.png", -1380, 200, 1},
      {"1a0cfa5b1d1.png", 400, -1000, 1},
      {"1a0cfa5c93e.png", 400, 200, 1},
    },
  }
  catalog["136691248-7037-26"] = scene
  published["@7985218"] = scene
end

-- 4T-4-vivantes/lava-bumpers
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0cfe3e4bc.png", -1380, -1000, 1},
      {"1a0cfe4cfe9.png", -1380, 200, 1},
      {"1a0d997462e.png", 800, -1000, 1},
      {"1a0d996b98b.png", 800, 200, 1},
    },
  }
  catalog["1339350618-13674-56"] = scene
  published["@7985214"] = scene
  catalog["345664733-13614-56"] = scene
  published["@7985729"] = scene
end

-- 4T-3-vivantes/lava-bumpers
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0d9afec95.png", -1380, -1000, 1},
      {"1a0d9af8f46.png", -1380, 200, 1},
      {"1a0d9af022e.png", 600, -1000, 1},
      {"1a0d9bb25f4.png", 600, 200, 1},
    },
  }
  catalog["871847179-59673-48"] = scene
  published["@7985215"] = scene
  catalog["589810116-59613-48"] = scene
  published["@7985730"] = scene
end

-- 4T-2-vivantes/lava-bumpers
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0cfbf1615.png", -1380, -1000, 1},
      {"1a0cfb0f231.png", -1380, 200, 1},
      {"1a0cfaec22f.png", 400, -1000, 1},
      {"1a0cfb065e0.png", 400, 200, 1},
    },
  }
  catalog["1189579043-23182-34"] = scene
  published["@7985212"] = scene
end

-- Normal-Large/water-barrier
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da194894.png", -1380, -1000, 1},
      {"1a0da17a29a.png", -1380, 200, 1},
      {"1a0da19312d.png", 600, -1000, 1},
      {"1a0da1817cf.png", 600, 200, 1},
    },
  }
  catalog["2122258609-4952-26"] = scene
  published["@7985230"] = scene
end

-- Normal-Large/sky-circles
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da207295.png", -1380, -1000, 1},
      {"1a0da1f41cd.png", -1380, 200, 1},
      {"1a0da20d05b.png", 600, -1000, 1},
      {"1a0da1f70b6.png", 600, 200, 1},
    },
  }
  catalog["1477308136-1901-24"] = scene
  published["@7984825"] = scene
end

-- Normal-Small/edge-trampolines
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da563b6c.png", -1380, -1000, 1},
      {"1a0da57cabe.png", -1380, 200, 1},
      {"1a0da56b0a5.png", 400, -1000, 1},
      {"1a0da5a0e29.png", 400, 200, 1},
    },
  }
  catalog["1091090761-8467-28"] = scene
  published["@7984833"] = scene
end

-- Normal-Large/edge-trampolines
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da3ed808.png", -1380, -1000, 1},
      {"1a0da3dbeb7.png", -1380, 200, 1},
      {"1a0da3d497b.png", 600, -1000, 1},
      {"1a0da3e4b5e.png", 600, 200, 1},
    },
  }
  catalog["1031981444-9635-28"] = scene
  published["@7984834"] = scene
end

-- Normal-Small/hidden-blocks
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da4f8db5.png", -1380, -1000, 1},
      {"1a0da54c454.png", -1380, 200, 1},
      {"1a0da544f16.png", 400, -1000, 1},
      {"1a0da55f519.png", 400, 200, 1},
    },
  }
  catalog["391272074-13488-28"] = scene
  published["@7984831"] = scene
end

-- Normal-Large/hidden-blocks
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da3a03c8.png", -1380, -1000, 1},
      {"1a0da3e7a42.png", -1380, 200, 1},
      {"1a0da3e0509.png", 600, -1000, 1},
      {"1a0da3cebb2.png", 600, 200, 1},
    },
  }
  catalog["1735625165-27850-33"] = scene
  published["@7984832"] = scene
end

-- Normal-Large/water-cannon
do
  local scene = {
    hideBorders=true,
    width=1200, height=400,
    pieces={
      {"1a0da18d36b.png", -1380, -1000, 1},
      {"1a0da1875a5.png", 600, -1000, 1},
    },
  }
  catalog["359639136-45139-42"] = scene
  published["@7984842"] = scene
end

-- Normal-Large/default
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da3f06eb.png", -1380, -1000, 1},
      {"1a0da463ae6.png", -1380, 200, 1},
      {"1a0da40208f.png", 600, -1000, 1},
      {"1a0da3f9394.png", 600, 200, 1},
    },
  }
  catalog["1417298003-58668-21"] = scene
  published["@7984816"] = scene
end

-- Normal-Large/ice-barrier
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0d9bd12cc.png", -1380, -1000, 1},
      {"1a0da39771b.png", -1380, 200, 1},
      {"1a0da39d4e1.png", 600, -1000, 1},
      {"1a0da39a600.png", 600, 200, 1},
    },
  }
  catalog["1768448475-477-24"] = scene
  published["@7985235"] = scene
end

-- Normal-Small/choco-floor
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da59df42.png", -1380, -1000, 1},
      {"1a0da578465.png", -1380, 200, 1},
      {"1a0da5681c1.png", 400, -1000, 1},
      {"1a0da5a6bec.png", 400, 200, 1},
    },
  }
  catalog["245039273-56023-20"] = scene
  published["@7984851"] = scene
end

-- Normal-Large/choco-floor
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da489cbd.png", -1380, -1000, 1},
      {"1a0da47b201.png", -1380, 200, 1},
      {"1a0da475437.png", 600, -1000, 1},
      {"1a0da482737.png", 600, 200, 1},
    },
  }
  catalog["1657347141-1170-24"] = scene
  published["@7984852"] = scene
end

-- Normal-Large/no-jump
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da324dfb.png", -1380, -1000, 1},
      {"1a0da620a84.png", -1380, 200, 1},
      {"1a0da31bec5.png", 600, -1000, 1},
      {"1a0da62396e.png", 600, 200, 1},
    },
  }
  catalog["1301781552-53646-19"] = scene
  published["@7984854"] = scene
end

-- Normal-Large/collision
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da3f64af.png", -1380, -1000, 1},
      {"1a0da4698b2.png", -1380, 200, 1},
      {"1a0da459713.png", 600, -1000, 1},
      {"1a0da3ff1b0.png", 600, 200, 1},
    },
  }
  catalog["1102018813-63164-23"] = scene
  published["@7984858"] = scene
end

-- Normal-Large/top-player
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da19bdd3.png", -1380, -1000, 1},
      {"1a0da190243.png", -1380, 200, 1},
      {"1a0da198eeb.png", 600, -1000, 1},
      {"1a0da1977a4.png", 600, 200, 1},
    },
  }
  catalog["1713614305-629-24"] = scene
  published["@7984862"] = scene
end

-- Normal-Small/inclined
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0f839a371.png", -1375.8281250000002, -913.549584460219, 2.3177083333333335, scaleY=1.8067227343698549},
    },
  }
  catalog["591573356-9885-27"] = scene
  published["@7984865"] = scene
end

-- Normal-Large/inclined
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0f8398bfa.png", -1374.5859375, -1001.9739468778951, 2.578125, scaleY=1.9587569497125945},
    },
  }
  catalog["407195134-12743-28"] = scene
  published["@7984866"] = scene
end

-- Normal-Large/sky-trampolines
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da614de9.png", -1380, -1000, 1},
      {"1a0da61abad.png", -1380, 200, 1},
      {"1a0da61f30b.png", 600, -1000, 1},
      {"1a0da61dc19.png", 600, 200, 1},
    },
  }
  catalog["27868905-14468-30"] = scene
  published["@7984869"] = scene
end

-- Normal-Large/spin-trampolines
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da1df99c.png", -1380, -1000, 1},
      {"1a0da1d9d60.png", -1380, 200, 1},
      {"1a0da1e6ed3.png", 600, -1000, 1},
      {"1a0da1a4a72.png", 600, 200, 1},
    },
  }
  catalog["854156443-1368-24"] = scene
  published["@7984878"] = scene
end

-- Normal-Large/black-water
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da4c86ef.png", -1380, -1000, 1},
      {"1a0da4911a2.png", -1380, 200, 1},
      {"1a0da48fa30.png", -390, 200, 1},
      {"1a0da488612.png", 600, -1000, 1},
      {"1a0da480fc1.png", 600, 200, 1},
      {"1a0da4c5ffe.png", 1590, 200, 1},
    },
  }
  catalog["437068317-60893-22"] = scene
  published["@7984882"] = scene
end

-- Normal-Small/chaos
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da59f6b2.png", -1380, -1000, 1},
      {"1a0da5a8360.png", -1380, 200, 1},
      {"1a0da579bd5.png", 400, -1000, 1},
      {"1a0da570e6e.png", 400, 200, 1},
    },
  }
  catalog["1712287273-4398-52"] = scene
  published["@7984885"] = scene
end

-- Normal-Large/chaos
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da48b3e6.png", -1380, -1000, 1},
      {"1a0da46df04.png", -1380, 200, 1},
      {"1a0da483ea6.png", 600, -1000, 1},
      {"1a0da47c973.png", 600, 200, 1},
    },
  }
  catalog["1776885729-2174-51"] = scene
  published["@7984886"] = scene
end

-- Normal-Large/cowebs
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da4580b6.png", -1380, -1000, 1},
      {"1a0da3fda40.png", -1380, 200, 1},
      {"1a0da45f496.png", 600, -1000, 1},
      {"1a0da3f4d45.png", 600, 200, 1},
    },
  }
  catalog["401819792-6781-27"] = scene
  published["@7984888"] = scene
end

-- Normal-Large/the-floor-is-lava
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0f8b647ea.png", -1380, -1000, 1},
      {"1a0f8b65f60.png", -1380, 200, 1},
      {"1a0f8b676c4.png", 600, -1000, 1},
      {"1a0f8b68e41.png", 600, 200, 1},
    },
  }
  catalog["122964921-14474-29"] = scene
  published["@7985246"] = scene
end

-- Normal-Large/choco-waters
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da634d5d.png", -1380, -1000, 1},
      {"1a0da46b021.png", -1380, 200, 1},
      {"1a0da630705.png", 600, -1000, 1},
      {"1a0da460c03.png", 600, 200, 1},
    },
  }
  catalog["86253651-60805-22"] = scene
  published["@7984897"] = scene
end

-- Normal-Large/bounce-diamonds
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da48e2c4.png", -1380, -1000, 1},
      {"1a0da486d8f.png", -1380, 200, 1},
      {"1a0da479a8d.png", 600, -1000, 1},
      {"1a0da47255e.png", 600, 200, 1},
    },
  }
  catalog["1852460807-2562-25"] = scene
  published["@7984901"] = scene
end

-- Normal-Large/honeymoon
do
  local scene = {
    hideBorders=true,
    width=1200, height=400,
    pieces={
      {"1a0da3ded98.png", -1380, -1000, 1},
      {"1a0da39ec5b.png", -1380, 200, 1},
      {"1a0da3d60ee.png", 600, -1000, 1},
      {"1a0da3cd4f3.png", 600, 200, 1},
    },
  }
  catalog["578030013-23555-33"] = scene
  published["@7984905"] = scene
end

-- Normal-Large/black-pond
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da4cfc27.png", -1380, -1000, 1},
      {"1a0da4c49e2.png", -1380, 200, 1},
      {"1a0d9c16bdb.png", 600, -1000, 1},
      {"1a0da4c9e63.png", 600, 200, 1},
    },
  }
  catalog["1860394395-60853-22"] = scene
  published["@7984909"] = scene
end

-- Normal-Small/kst-small
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da55c634.png", -1380, -1000, 1},
      {"1a0da4f763d.png", -1380, 200, 1},
      {"1a0da4feb78.png", 400, -1000, 1},
      {"1a0da553985.png", 400, 200, 1},
    },
  }
  catalog["1453396622-15600-30"] = scene
  published["@7984916"] = scene
  catalog["3798621-15540-30"] = scene
  published["@7985725"] = scene
end

-- Normal-Large/kst-small
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da3715b0.png", -1380, -1000, 1},
      {"1a0da38d308.png", -1380, 200, 1},
      {"1a0da316104.png", 600, -1000, 1},
      {"1a0da372d0e.png", 600, 200, 1},
    },
  }
  catalog["2004433308-15967-30"] = scene
  published["@7984917"] = scene
  catalog["28819732-15907-30"] = scene
  published["@7985726"] = scene
end

-- Normal-Small/date
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da59c80b.png", -1380, -1000, 1},
      {"1a0da566a4d.png", -490, -1000, 1},
      {"1a0da575602.png", -1380, 200, 1},
      {"1a0da5a3d0c.png", 400, -1000, 1},
      {"1a0da56c819.png", 400, 200, 1},
    },
  }
  catalog["1758659694-5496-26"] = scene
  published["@7984914"] = scene
end

-- Normal-Large/date
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da3f1e5d.png", -1380, -1000, 1},
      {"1a0da4669c5.png", -390, -1000, 1},
      {"1a0da45c5ac.png", -1380, 200, 1},
      {"1a0da45dd1f.png", -390, 200, 1},
      {"1a0da465259.png", 600, -1000, 1},
      {"1a0da3fab01.png", 600, 200, 1},
      {"1a0da403801.png", 1590, 200, 1},
    },
  }
  catalog["682168558-8300-27"] = scene
  published["@7984915"] = scene
end

-- Normal-Large/snowy-mountains
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da1de22a.png", -1380, -1000, 1},
      {"1a0da1a90be.png", -1380, 200, 1},
      {"1a0da1aa833.png", 600, -1000, 1},
      {"1a0da1e9db3.png", 600, 200, 1},
    },
  }
  catalog["1135688223-1185-50"] = scene
  published["@7985680"] = scene
end

-- Normal-Large/eclipse
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da462373.png", -1380, -1000, 1},
      {"1a0da3dd628.png", -1380, 200, 1},
      {"1a0da3e62cd.png", 600, -1000, 1},
      {"1a0da62ef98.png", 600, 200, 1},
    },
  }
  catalog["1810660744-45087-40"] = scene
  published["@7985264"] = scene
end

-- Normal-Small/small-bat-2
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da4d88cc.png", -1380, -1000, 1},
      {"1a0da4d2b0c.png", -1380, 200, 1},
      {"1a0da4ce4b5.png", 400, -1000, 1},
      {"1a0da4dcf24.png", 400, 200, 1},
    },
  }
  catalog["1737663745-52271-65"] = scene
  published["@7984926"] = scene
end

-- Normal-Large/small-bat-2
do
  local scene = {
    width=1200, height=400,
    -- The XML walls extend 95px beyond each side of the viewport.
    borderSearchMargin=95,
    pieces={
      {"1a0da1e3fee.png", -1380, -1000, 1},
      {"1a0da1eb522.png", -1380, 200, 1},
      {"1a0da1f5946.png", 600, -1000, 1},
      {"1a0da1fb70b.png", 600, 200, 1},
    },
  }
  catalog["1868677844-55024-65"] = scene
  published["@7984927"] = scene
end

-- Normal-Large/ice-collision
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da38a430.png", -1380, -1000, 1},
      {"1a0da6250d0.png", -1380, 200, 1},
      {"1a0da62d826.png", -390, 200, 1},
      {"1a0da37736f.png", 600, -1000, 1},
      {"1a0da62c0b4.png", 600, 200, 1},
      {"1a0da37e8a3.png", 1590, 200, 1},
    },
  }
  catalog["1441136934-54034-19"] = scene
  published["@7984933"] = scene
  catalog["794103386-53974-19"] = scene
  published["@7985713"] = scene
end

-- Normal-Small/uranus-is-cold
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0f83a30fc.png", -1136, -861, 2, scaleY=2},
    },
  }
  catalog["360829589-43147-39"] = scene
  published["@7984937"] = scene
  catalog["1380693403-43046-39"] = scene
  published["@7985753"] = scene
end

-- Normal-Large/uranus-is-cold
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0f83a30fc.png", -936, -861, 2, scaleY=2},
    },
  }
  catalog["2047857447-48301-40"] = scene
  published["@7984938"] = scene
end

-- Normal-Small/lacostes
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da54956f.png", -1380, -1000, 1},
      {"1a0da55221f.png", -1380, 200, 1},
      {"1a0da4f6109.png", 400, -1000, 1},
      {"1a0da55aec3.png", 400, 200, 1},
    },
  }
  catalog["1650000931-34229-58"] = scene
  published["@7984939"] = scene
  catalog["1296964820-34169-58"] = scene
  published["@7985727"] = scene
end

-- Normal-Large/lacostes
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da36fe3f.png", -1380, -1000, 1},
      {"1a0da30d451.png", -1380, 200, 1},
      {"1a0da31eda4.png", -390, 200, 1},
      {"1a0da31d63a.png", 600, -1000, 1},
      {"1a0da314982.png", 600, 200, 1},
      {"1a0da327cd5.png", 1590, 200, 1},
    },
  }
  catalog["960938660-38938-60"] = scene
  published["@7984940"] = scene
  catalog["570761915-38878-60"] = scene
  published["@7985728"] = scene
end

-- Normal-Large/ice-booster
do
  local scene = {
    hideBorders=true,
    width=1200, height=400,
    pieces={
      {"1a0da398e8e.png", -1380, -1000, 1},
      {"1a0da3930d0.png", -1380, 200, 1},
      {"1a0da39c068.png", -390, 200, 1},
      {"1a0da378adb.png", 600, -1000, 1},
      {"1a0da394841.png", 600, 200, 1},
      {"1a0da395fa6.png", 1590, 200, 1},
    },
  }
  catalog["297192898-38457-36"] = scene
  published["@7984943"] = scene
  catalog["211868085-38397-36"] = scene
  published["@7985709"] = scene
end

-- Normal-Large/light-dark
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da30bcde.png", -1380, -1000, 1},
      {"1a0da31321d.png", -1380, 200, 1},
      {"1a0da326561.png", 600, -1000, 1},
      {"1a0da36e6c6.png", 600, 200, 1},
    },
  }
  catalog["1376289201-41597-38"] = scene
  published["@7984947"] = scene
  catalog["1549457542-41537-38"] = scene
  published["@7985732"] = scene
end

-- Normal-Small/cyberpink-2
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da576cf6.png", -1380, -1000, 1},
      {"1a0da56df89.png", -1380, 200, 1},
      {"1a0da56f701.png", 400, -1000, 1},
      {"1a0da5a547d.png", 400, 200, 1},
    },
  }
  catalog["243919337-61700-91"] = scene
  published["@7984950"] = scene
end

-- Normal-Large/cyberpink-2
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da46813a.png", -1380, -1000, 1},
      {"1a0da3f35cd.png", -1380, 200, 1},
      {"1a0da404f77.png", 600, -1000, 1},
      {"1a0da3fc53b.png", 600, 200, 1},
    },
  }
  catalog["629426588-48481-63"] = scene
  published["@7984951"] = scene
end

-- Normal-Large/volley-2-0
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da18ead4.png", -1380, -1000, 1},
      {"1a0da17ba0c.png", -1380, 200, 1},
      {"1a0da188d06.png", 600, -1000, 1},
      {"1a0da182f3e.png", 600, 200, 1},
    },
  }
  catalog["1186798916-64101-23"] = scene
  published["@7984954"] = scene
end

-- Normal-Small/soccer
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da4e1576.png", -1380, -1000, 1},
      {"1a0da4ccd46.png", -1380, 200, 1},
      {"1a0da4e2ce7.png", -490, 200, 1},
      {"1a0da4db7b0.png", 400, -1000, 1},
      {"1a0da4d715f.png", 400, 200, 1},
      {"1a0da4d1395.png", 1290, 200, 1},
    },
  }
  catalog["1264399342-41470-61"] = scene
  published["@7984957"] = scene
end

-- Normal-Large/soccer
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da1efb7b.png", -1380, -1000, 1},
      {"1a0da1f12ea.png", -1380, 200, 1},
      {"1a0da1e863b.png", -390, 200, 1},
      {"1a0da1a794a.png", 600, -1000, 1},
      {"1a0da1e287c.png", 600, 200, 1},
      {"1a0da1dcab5.png", 1590, 200, 1},
    },
  }
  catalog["939945828-42800-61"] = scene
  published["@7984958"] = scene
end

-- Normal-Large/pink-date
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da2f8c29.png", -1380, -1000, 1},
      {"1a0da30015c.png", -1380, 200, 1},
      {"1a0da320787.png", 600, -1000, 1},
      {"1a0da3047b1.png", 600, 200, 1},
      {"1a0da329437.png", 523, 106, 1, layer="!1000"},
    },
  }
  catalog["1244156286-2699-25"] = scene
  published["@7984971"] = scene
end

-- Normal-Large/kralizmox
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da380017.png", -1380, -1000, 1},
      {"1a0da385de1.png", -1380, 200, 1},
      {"1a0da37a245.png", 600, -1000, 1},
      {"1a0da374486.png", 600, 200, 1},
      {"1a0da38ea7d.png", 1590, 200, 1},
    },
  }
  catalog["298514686-64647-23"] = scene
  published["@7985260"] = scene
  catalog["1514548737-64537-23"] = scene
  published["@7985721"] = scene
end

-- Normal-Large/the-rainbow
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da19a657.png", -1380, -1000, 1},
      {"1a0da1a1e6a.png", -1380, 200, 1},
      {"1a0da1a340e.png", 600, -1000, 1},
      {"1a0da19eca9.png", 600, 200, 1},
    },
  }
  catalog["789572205-44067-61"] = scene
  published["@7984976"] = scene
end

-- Normal-Large/platforms
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da2fbb0b.png", -1380, -1000, 1},
      {"1a0da2f45d7.png", 600, -1000, 1},
    },
  }
  catalog["795274638-50126-44"] = scene
  published["@7984980"] = scene
  published["@7985273"] = scene
end

-- Normal-Large/some-chords
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da1e112c.png", -1380, -1000, 1},
      {"1a0da619441.png", -1380, 200, 1},
      {"1a0da1db34d.png", 600, -1000, 1},
      {"1a0da1a61e8.png", 600, 200, 1},
    },
  }
  catalog["1083064335-60707-21"] = scene
  published["@7984984"] = scene
end

-- Normal-Small/revamped-soccer
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da4ea221.png", -1380, -1000, 1},
      {"1a0da4ed107.png", -1380, 200, 1},
      {"1a0da4e8aaf.png", 400, -1000, 1},
      {"1a0da4e5bcf.png", 400, 200, 1},
    },
  }
  catalog["1357855601-17542-54"] = scene
  published["@7984987"] = scene
end

-- Normal-Large/revamped-soccer
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da1ffd63.png", -1380, -1000, 1},
      {"1a0da2014c9.png", -1380, 200, 1},
      {"1a0da205b21.png", -390, 200, 1},
      {"1a0da20a420.png", 600, -1000, 1},
      {"1a0da20b901.png", 600, 200, 1},
      {"1a0da20ff3d.png", 1590, 200, 1},
    },
  }
  catalog["890188516-43622-40"] = scene
  published["@7984988"] = scene
end

-- Normal-Small/brazhell-soccer
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da5b566b.png", -1380, -1000, 1},
      {"1a0da5c40e2.png", -1380, 200, 1},
      {"1a0da5ab243.png", 400, -1000, 1},
      {"1a0da5a9ad2.png", 400, 200, 1},
    },
  }
  catalog["346073253-1976-48"] = scene
  published["@7984993"] = scene
end

-- Normal-Large/brazhell-soccer
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da470de8.png", -1380, -1000, 1},
      {"1a0da48cb55.png", -1380, 200, 1},
      {"1a0da47f85a.png", 600, -1000, 1},
      {"1a0da47831c.png", 600, 200, 1},
    },
  }
  catalog["2129172144-3812-48"] = scene
  published["@7984994"] = scene
end

-- Normal-Large/no-jump-tower
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da31032f.png", -1380, -1000, 1},
      {"1a0da311aa5.png", -1380, 200, 1},
      {"1a0da323764.png", -390, 200, 1},
      {"1a0da36b919.png", 600, -1000, 1},
      {"1a0da308dfb.png", 600, 200, 1},
      {"1a0da36cf72.png", 1590, 200, 1},
    },
  }
  catalog["221055177-44576-40"] = scene
  published["@7984996"] = scene
end

-- Normal-Large/quad-cannons
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da2f175c.png", -1380, -1000, 1},
      {"1a0da2fa392.png", -1380, 200, 1},
      {"1a0da2f2e59.png", -390, 200, 1},
      {"1a0da2116af.png", 600, -1000, 1},
      {"1a0da2f5d3b.png", 600, 200, 1},
      {"1a0da3018c9.png", 1590, 200, 1},
    },
  }
  catalog["278744286-34291-39"] = scene
  published["@7985006"] = scene
end

-- Normal-Small/frozen-soccer
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da54f336.png", -1380, -1000, 1},
      {"1a0da547df9.png", -1380, 200, 1},
      {"1a0da4fbc94.png", -490, 200, 1},
      {"1a0da557fdf.png", 400, -1000, 1},
      {"1a0da560c91.png", 400, 200, 1},
    },
  }
  catalog["1363422216-40765-63"] = scene
  published["@7985239"] = scene
end

-- Normal-Large/frozen-soccer
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da3d8fd3.png", -1380, -1000, 1},
      {"1a0da3e33eb.png", -1380, 200, 1},
      {"1a0da3d1a93.png", -390, 200, 1},
      {"1a0da3e1c84.png", 600, -1000, 1},
      {"1a0da3a32a5.png", 600, 200, 1},
      {"1a0da3ea924.png", 1590, 200, 1},
    },
  }
  catalog["1654785041-2624-51"] = scene
  published["@7985240"] = scene
end

-- Normal-Small/der-lifter
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da59b21f.png", -1380, -1000, 1},
      {"1a0da5652e4.png", -1380, 200, 1},
      {"1a0da5a25a0.png", 400, -1000, 1},
      {"1a0da574071.png", 400, 200, 1},
    },
  }
  catalog["1313682024-52738-42"] = scene
  published["@7985013"] = scene
end

-- Normal-Large/der-lifter
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da45ae42.png", -1380, -1000, 1},
      {"1a0da400922.png", -1380, 200, 1},
      {"1a0da3f7c20.png", 600, -1000, 1},
      {"1a0da3eef7b.png", 600, 200, 1},
    },
  }
  catalog["1411125234-53046-42"] = scene
  published["@7985014"] = scene
end

-- Normal-Small/handball
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da54dbc4.png", -1380, -1000, 1},
      {"1a0da4fa528.png", -1380, 200, 1},
      {"1a0da54668d.png", 400, -1000, 1},
      {"1a0da55686c.png", 400, 200, 1},
    },
  }
  catalog["459691539-54015-67"] = scene
  published["@7985015"] = scene
end

-- Normal-Large/handball
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da3d7861.png", -1380, -1000, 1},
      {"1a0da3e91b4.png", -1380, 200, 1},
      {"1a0da3a1b71.png", 600, -1000, 1},
      {"1a0da3d0325.png", 600, 200, 1},
    },
  }
  catalog["104315601-10118-74"] = scene
  published["@7985016"] = scene
end

-- Normal-Large/portal-soccer
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da30303d.png", -1380, -1000, 1},
      {"1a0da2fd26f.png", -1380, 200, 1},
      {"1a0da2fe9e8.png", 600, -1000, 1},
      {"1a0da2f74b5.png", 600, 200, 1},
    },
  }
  catalog["1979431917-44886-64"] = scene
  published["@7985018"] = scene
end

-- Normal-Large/cannon-soccer
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da485618.png", -1380, -1000, 1},
      {"1a0da476bae.png", -1380, 200, 1},
      {"1a0da47e0e3.png", 600, -1000, 1},
      {"1a0da46f679.png", 600, 200, 1},
    },
  }
  catalog["421354534-29679-58"] = scene
  published["@7985020"] = scene
end

-- Normal-Large/eeerie-basement
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da3a4a1a.png", -1380, -1000, 1},
      {"1a0da3ec09c.png", -1380, 200, 1},
      {"1a0da3d320c.png", 600, -1000, 1},
      {"1a0da3da743.png", 600, 200, 1},
    },
  }
  catalog["1468357515-56117-90"] = scene
  published["@7985022"] = scene
end

-- Normal-Large/impostor
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da3901ee.png", -1380, -1000, 1},
      {"1a0da375bf5.png", -1380, 200, 1},
      {"1a0da37d135.png", 600, -1000, 1},
      {"1a0da382efb.png", 600, 200, 1},
    },
  }
  catalog["1133007324-6310-26"] = scene
  published["@7985024"] = scene
  catalog["799128197-6250-26"] = scene
  published["@7985717"] = scene
end

-- Normal-Large/ocean
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da305f1b.png", -1380, -1000, 1},
      {"1a0da317870.png", -1380, 200, 1},
      {"1a0da30ebc7.png", -390, 200, 1},
      {"1a0da307687.png", 600, -1000, 1},
      {"1a0da318fd6.png", 600, 200, 1},
      {"1a0da6221ec.png", 1590, 200, 1},
    },
  }
  catalog["1808227127-59299-21"] = scene
  published["@7985035"] = scene
  catalog["693524545-59239-21"] = scene
  published["@7985736"] = scene
end

-- Normal-Small/squad
do
  local scene = {
    width=1600, height=800,
    pieces={
      {"1a0cfa4c764.png", -1380, -1000, 1},
      {"1a0cfa4dece.png", -1380, 400, 1},
      {"1a0cfa4f644.png", 800, -1000, 1},
      {"1a0cfa50dba.png", 800, 400, 1},
    },
  }
  catalog["1864146971-27340-59"] = scene
  published["@7985038"] = scene
end

-- Normal-Large/squad
do
  local scene = {
    width=3200, height=800,
    pieces={
      {"1a0cfa52524.png", -1380, -1000, 1},
      {"1a0cfa53c9e.png", 110, -1000, 1},
      {"1a0cfa5540e.png", 1600, -1000, 1},
      {"1a0cfa56b79.png", 3090, -1000, 1},
    },
  }
  catalog["132745405-29924-60"] = scene
  published["@7985039"] = scene
end

-- Normal-Large/lava-bumpers
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0d9afec95.png", -1380, -1000, 1},
      {"1a0d9af8f46.png", -1380, 200, 1},
      {"1a0d9af022e.png", 600, -1000, 1},
      {"1a0d9bb25f4.png", 600, 200, 1},
    },
  }
  catalog["1258496599-30784-37"] = scene
  published["@7985213"] = scene
end

-- Mode-3T-3-vivantes/default
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0da17e8f8.png", -1380, -1000, 1},
      {"1a0da18bbf9.png", -1380, 200, 1},
      {"1a0da185e26.png", 900, -1000, 1},
      {"1a0da1919bb.png", 900, 200, 1},
    },
  }
  catalog["889308884-7140-26"] = scene
  published["@7984818"] = scene
  catalog["1056357966-7080-26"] = scene
  published["@7985693"] = scene
end

-- Mode-3T-3-vivantes/ice-barrier
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0da0b9539.png", -1380, -1000, 1},
      {"1a0da0b1f13.png", -1380, 200, 1},
      {"1a0da175c42.png", 900, -1000, 1},
      {"1a0da0b7ce0.png", 900, 200, 1},
    },
  }
  catalog["842369232-9200-27"] = scene
  published["@7985237"] = scene
end

-- Mode-3T-3-vivantes/sky-circles
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0da0bdaa3.png", -1380, -1000, 1},
      {"1a0da0a7afe.png", -1380, 200, 1},
      {"1a0da0a34a2.png", 900, -1000, 1},
      {"1a0da0af030.png", 900, 200, 1},
    },
  }
  catalog["1808169034-18073-30"] = scene
  published["@7984827"] = scene
  catalog["1697002861-18013-30"] = scene
  published["@7985744"] = scene
end

-- Mode-3T-3-vivantes/ice-collision
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0da0a926c.png", -1380, -1000, 1},
      {"1a0da0aa9e3.png", -1380, 200, 1},
      {"1a0da0b07a9.png", -240, 200, 1},
      {"1a0da0b656f.png", 900, -1000, 1},
      {"1a0da0bf213.png", 900, 200, 1},
      {"1a0da0a4c1c.png", 2040, 200, 1},
    },
  }
  catalog["293671015-59322-21"] = scene
  published["@7984936"] = scene
end

-- Mode-3T-3-vivantes/water-cannon
do
  local scene = {
    hideBorders=true,
    width=1800, height=400,
    pieces={
      {"1a0da0bc336.png", -1380, -1000, 1},
      {"1a0da0a1d33.png", -1380, 200, 1},
      {"1a0da0b4dfc.png", 900, -1000, 1},
    },
  }
  catalog["1128677027-50880-44"] = scene
  published["@7984844"] = scene
end

-- Normal-Extra-Large/default
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0f8b7036a.png", -1380, -1000, 1},
      {"1a0f8b71ae4.png", -1380, 200, 1},
      {"1a0f8b7324e.png", 900, -1000, 1},
      {"1a0f8b749ce.png", 900, 200, 1},
    },
  }
  catalog["1137924375-926-24"] = scene
  catalog["1253208634-866-24"] = scene
end

-- Real/default
do
  local scene = {
    width=2600, height=400,
    pieces={
      {"1a0f8b76135.png", -1380, -1000, 1},
      {"1a0f8b778a5.png", -1380, 200, 1},
      {"1a0f8b7901c.png", -40, -1000, 1},
      {"1a0f8b7a78b.png", 1300, -1000, 1},
      {"1a0f8b7bf02.png", 2640, -1000, 1},
    },
  }
  catalog["2079965383-13046-28"] = scene
  catalog["1240057862-12986-28"] = scene
end

-- Abyssal-Tide-backgrounds/four_two
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0dc9aa21d.png", -800, -760, 1},
      {"1a0dc9ab99f.png", 400, -760, 1},
    },
  }
  catalog["159660057-27943-57"] = scene
  catalog["1913737348-27980-57"] = scene
  published["@7985424"] = scene
end

-- Abyssal-Tide-backgrounds/three_reduced
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0dc9a746f.png", -800, -741, 1},
      {"1a0dc9a8abd.png", 600, -741, 1},
    },
  }
  catalog["1133663579-30597-57"] = scene
  catalog["1838298683-30634-57"] = scene
  published["@7985425"] = scene
end

-- Abyssal-Tide-backgrounds/normal_xl
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0dc9a157b.png", -800, -777, 1},
      {"1a0dc9a2cf1.png", -800, 123, 1},
      {"1a0dc9a4467.png", 900, -777, 1},
      {"1a0dc9a5bd4.png", 900, 123, 1},
    },
  }
  catalog["873333026-32773-57"] = scene
  catalog["765418331-32810-57"] = scene
end

-- Abyssal-Tide-backgrounds/four
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0dc994358.png", -800, -771, 1},
      {"1a0dc9959ec.png", 800, -771, 1},
      {"1a0dc997160.png", 800, 129, 1},
    },
  }
  catalog["965028882-27918-59"] = scene
  catalog["1275534270-27955-59"] = scene
  published["@7985426"] = scene
end

-- Abyssal-Tide-backgrounds/three
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0dc9988d0.png", -800, -809, 1},
      {"1a0dc99a03a.png", -800, 91, 1},
      {"1a0dc99b7b2.png", 900, -809, 1},
      {"1a0dc99cf26.png", 900, 91, 1},
    },
  }
  catalog["1077929057-62970-47"] = scene
  catalog["665444351-63007-47"] = scene
  published["@7985427"] = scene
end

-- Abyssal-Tide-backgrounds/four_three
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0dc99e69c.png", -800, -738, 1},
      {"1a0dc99fe15.png", 600, -738, 1},
    },
  }
  catalog["1341724065-61047-47"] = scene
  catalog["1845722808-61084-47"] = scene
  published["@7985428"] = scene
end

-- Black-Hole-backgrounds/four_two
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0dc89e3bc.png", -800, -833, 1},
      {"1a0dc89fb26.png", 400, -833, 1},
    },
  }
  catalog["1910353760-63347-44"] = scene
  catalog["788843255-479-45"] = scene
  published["@7985419"] = scene
end

-- Black-Hole-backgrounds/three_reduced
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0dc89b4df.png", -800, -729, 1},
      {"1a0dc89cc57.png", 600, -729, 1},
    },
  }
  catalog["199550533-21885-30"] = scene
  catalog["657816765-24583-31"] = scene
  published["@7985420"] = scene
end

-- Black-Hole-backgrounds/normal_xl
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0dc895710.png", -800, -852, 1},
      {"1a0dc896e7b.png", -800, 48, 1},
      {"1a0dc8985ed.png", 900, -852, 1},
      {"1a0dc899d61.png", 900, 48, 1},
    },
  }
  catalog["232960129-22122-30"] = scene
  catalog["2038814688-24792-31"] = scene
  catalog["437739133-24829-31"] = scene
  published["@7984757"] = scene
end

-- Black-Hole-backgrounds/four
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0dc8886c0.png", -800, -811, 1},
      {"1a0dc889b80.png", -800, 89, 1},
      {"1a0dc88b301.png", 800, -811, 1},
    },
  }
  catalog["387200682-46857-60"] = scene
  catalog["1434834853-46656-60"] = scene
  published["@7985421"] = scene
end

-- Black-Hole-backgrounds/three
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0dc88ca69.png", -800, -781, 1},
      {"1a0dc88e1d9.png", -800, 119, 1},
      {"1a0dc88f953.png", 900, -781, 1},
      {"1a0dc8910c0.png", 900, 119, 1},
    },
  }
  catalog["813728279-1893-45"] = scene
  catalog["1771095193-4600-46"] = scene
  published["@7985422"] = scene
end

-- Black-Hole-backgrounds/four_three
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0dc89283d.png", -800, -840, 1},
      {"1a0dc893fae.png", 600, -840, 1},
    },
  }
  catalog["1712816736-1392-45"] = scene
  catalog["906081015-4090-46"] = scene
  published["@7985423"] = scene
end

-- Neon-Reactor-backgrounds/four_two
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0dc872acb.png", -800, -689, 1},
      {"1a0dc874321.png", 400, -689, 1},
    },
  }
  catalog["462302972-59733-44"] = scene
  catalog["134631325-59770-44"] = scene
  published["@7985414"] = scene
end

-- Neon-Reactor-backgrounds/three_reduced
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0dc86fc85.png", -800, -675, 1},
      {"1a0dc871381.png", 600, -675, 1},
    },
  }
  catalog["390912037-62809-44"] = scene
  catalog["1157952105-62846-44"] = scene
  published["@7985415"] = scene
end

-- Neon-Reactor-backgrounds/normal_xl
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0dc86ca2d.png", -800, -700, 1},
      {"1a0dc86e194.png", 900, -700, 1},
    },
  }
  catalog["1702101070-65391-44"] = scene
  catalog["1557538685-65428-44"] = scene
  published["@7984661"] = scene
end

-- Neon-Reactor-backgrounds/four
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0dc860ea1.png", -800, -708, 1},
      {"1a0dc862608.png", 800, -708, 1},
    },
  }
  catalog["1346157954-39480-59"] = scene
  catalog["1075748374-39517-59"] = scene
  published["@7985416"] = scene
end

-- Neon-Reactor-backgrounds/three
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0dc863d78.png", -800, -789, 1},
      {"1a0dc8654dd.png", -800, 111, 1},
      {"1a0dc866c5d.png", 900, -789, 1},
      {"1a0dc8683d2.png", 900, 111, 1},
    },
  }
  catalog["1795429764-5001-47"] = scene
  catalog["155760905-5038-47"] = scene
  published["@7985417"] = scene
end

-- Neon-Reactor-backgrounds/four_three
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0dc869b42.png", -800, -733, 1},
      {"1a0dc86b2ae.png", 600, -733, 1},
    },
  }
  catalog["1951992032-4239-47"] = scene
  catalog["159308069-4276-47"] = scene
  published["@7985418"] = scene
end

-- Sky-Temple-backgrounds/four_two
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0dc853b32.png", -800, -762, 1},
      {"1a0dc8552a3.png", -800, 138, 1},
      {"1a0dc856a23.png", 400, -762, 1},
    },
  }
  catalog["1083277023-3767-47"] = scene
  catalog["889198566-3708-47"] = scene
  published["@7985409"] = scene
end

-- Sky-Temple-backgrounds/three_reduced
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0dc84dd70.png", -800, -767, 1},
      {"1a0dc84f4e6.png", -800, 133, 1},
      {"1a0dc850c52.png", 600, -767, 1},
      {"1a0dc8523c7.png", 600, 133, 1},
    },
  }
  catalog["987540983-6330-47"] = scene
  catalog["1234808513-6271-47"] = scene
  published["@7985410"] = scene
end

-- Sky-Temple-backgrounds/normal_xl
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0dc847fac.png", -800, -734, 1},
      {"1a0dc849721.png", -800, 166, 1},
      {"1a0dc84ae8d.png", 900, -734, 1},
      {"1a0dc84c607.png", 900, 166, 1},
    },
  }
  catalog["1229807852-10305-47"] = scene
  catalog["1205044676-10246-47"] = scene
  published["@7984639"] = scene
end

-- Sky-Temple-backgrounds/four
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0dc83694f.png", -800, -725, 1},
      {"1a0dc837dd3.png", -800, 175, 1},
      {"1a0dc83953a.png", 800, -725, 1},
      {"1a0dc83acac.png", 800, 175, 1},
    },
  }
  catalog["395127669-30380-56"] = scene
  catalog["1398466806-30321-56"] = scene
  published["@7985411"] = scene
end

-- Sky-Temple-backgrounds/three
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0dc83c41d.png", -800, -743, 1},
      {"1a0dc83db95.png", -800, 157, 1},
      {"1a0dc83f2f9.png", 900, -743, 1},
      {"1a0dc840a6e.png", 900, 157, 1},
    },
  }
  catalog["196709261-64437-45"] = scene
  catalog["1171718915-64378-45"] = scene
  published["@7985412"] = scene
end

-- Sky-Temple-backgrounds/four_three
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0dc8421e0.png", -800, -767, 1},
      {"1a0dc843955.png", -800, 133, 1},
      {"1a0dc8450c0.png", 600, -767, 1},
      {"1a0dc846839.png", 600, 133, 1},
    },
  }
  catalog["750588942-63816-45"] = scene
  catalog["1712080561-63757-45"] = scene
  published["@7985413"] = scene
end

-- Storm Core / normal_small
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0f82938e5.png", -800, -802, 1},
      {"1a0f8294f7d.png", 400, -802, 1},
    },
  }
  catalog["2074728831-42326-38"] = scene
  catalog["365057822-42363-38"] = scene
  published["@7985429"] = scene
end

-- Storm Core / normal_large
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0f82908c2.png", -800, -791, 1},
      {"1a0f82921eb.png", 600, -791, 1},
    },
  }
  catalog["1273590666-10080-25"] = scene
  catalog["764817311-10117-25"] = scene
  published["@7985430"] = scene
end

-- Storm Core / two
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0f8284ecf.png", -800, -800, 1},
      {"1a0f8286554.png", 800, -800, 1},
    },
  }
  catalog["1145050908-40142-53"] = scene
  catalog["1444996007-40179-53"] = scene
  published["@7985431"] = scene
end

-- Storm Core / three
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0f8287c1f.png", -800, -802, 1},
      {"1a0f8289399.png", 900, -802, 1},
    },
  }
  catalog["907925187-725-41"] = scene
  catalog["721521547-762-41"] = scene
  published["@7985432"] = scene
end

-- Storm Core / four_three
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0f828aaff.png", -800, -800, 1},
      {"1a0f828c271.png", 600, -800, 1},
    },
  }
  catalog["1691160087-394-41"] = scene
  catalog["824567480-431-41"] = scene
  published["@7985433"] = scene
end

-- Storm Core / normal_xl
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0f8b7d67b.png", -800, -800, 1},
      {"1a0f8b7ede4.png", 900, -800, 1},
    },
  }
  catalog["1005367829-10203-25"] = scene
  catalog["1594759802-10240-25"] = scene
end

-- Magma Forge / normal_small
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0f82a997b.png", -800, -754, 1},
      {"1a0f82aaf68.png", 400, -754, 1},
    },
  }
  catalog["1730966166-46233-40"] = scene
  catalog["43018101-46270-40"] = scene
  published["@7985434"] = scene
end

-- Magma Forge / normal_large
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0f82a6875.png", -800, -797, 1},
      {"1a0f82a7fe4.png", 600, -797, 1},
    },
  }
  catalog["458222008-26071-32"] = scene
  catalog["1222244804-26108-32"] = scene
  published["@7985435"] = scene
end

-- Magma Forge / two
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0f829668e.png", -800, -756, 1},
      {"1a0f8297e04.png", 800, -756, 1},
      {"1a0f829956e.png", 800, 144, 1},
    },
  }
  catalog["1705202265-26455-56"] = scene
  catalog["1593871025-26492-56"] = scene
  published["@7985436"] = scene
end

-- Magma Forge / three
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0f829acdf.png", -800, -765, 1},
      {"1a0f829c456.png", 900, -765, 1},
    },
  }
  catalog["984482707-61743-44"] = scene
  catalog["911373147-61780-44"] = scene
  published["@7985437"] = scene
end

-- Magma Forge / four_three
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0f829dbbf.png", -800, -760, 1},
      {"1a0f829f337.png", 600, -760, 1},
    },
  }
  catalog["507428460-58064-44"] = scene
  catalog["600161169-58101-44"] = scene
  published["@7985438"] = scene
end

-- Magma Forge / normal_xl
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0f82a0a99.png", -800, -759, 1},
      {"1a0f82a220f.png", -800, 141, 1},
      {"1a0f82a397b.png", 900, -759, 1},
      {"1a0f82a50fc.png", 900, 141, 1},
    },
  }
  catalog["386679188-27818-32"] = scene
  catalog["1706816881-27855-32"] = scene
end

-- Crystal Rift / normal_small
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0f833c658.png", -800, -794, 1},
      {"1a0f833ddc8.png", 400, -794, 1},
    },
  }
  catalog["767753377-48959-40"] = scene
  catalog["1049806518-48996-40"] = scene
  published["@7985439"] = scene
end

-- Crystal Rift / normal_large
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0f833688c.png", -800, -780, 1},
      {"1a0f8337ff8.png", -800, 120, 1},
      {"1a0f8339769.png", 600, -780, 1},
      {"1a0f833aedb.png", 600, 120, 1},
    },
  }
  catalog["998373879-22995-31"] = scene
  catalog["263422715-23032-31"] = scene
  published["@7985440"] = scene
end

-- Crystal Rift / two
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0f82ac6d7.png", -800, -782, 1},
      {"1a0f82ade4a.png", -800, 118, 1},
      {"1a0f82af5b5.png", 800, -782, 1},
      {"1a0f82b0d24.png", 800, 118, 1},
    },
  }
  catalog["66756022-20743-53"] = scene
  catalog["1817984106-20780-53"] = scene
  published["@7985441"] = scene
end

-- Crystal Rift / three
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0f82b249f.png", -800, -793, 1},
      {"1a0f82b3c08.png", -800, 107, 1},
      {"1a0f83280c6.png", 900, -793, 1},
      {"1a0f832964e.png", 900, 107, 1},
    },
  }
  catalog["966837684-54975-42"] = scene
  catalog["1988200167-55012-42"] = scene
  published["@7985453"] = scene
end

-- Crystal Rift / four_three
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0f832acfa.png", -800, -802, 1},
      {"1a0f832c46d.png", -800, 98, 1},
      {"1a0f832dbde.png", 600, -802, 1},
      {"1a0f832f37a.png", 600, 98, 1},
    },
  }
  catalog["76088704-54372-42"] = scene
  catalog["1737353348-54409-42"] = scene
  published["@7985442"] = scene
end

-- Crystal Rift / normal_xl
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0f8330ac0.png", -800, -799, 1},
      {"1a0f8332229.png", -800, 101, 1},
      {"1a0f83339ad.png", 900, -799, 1},
      {"1a0f8335121.png", 900, 101, 1},
    },
  }
  catalog["226361810-23439-31"] = scene
  catalog["508284543-23476-31"] = scene
end

-- Rose Garden / normal_small
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0f835ca43.png", -800, -739, 1},
      {"1a0f835e1b3.png", -800, 161, 1},
      {"1a0f835f924.png", 400, -739, 1},
      {"1a0f8361095.png", 400, 161, 1},
    },
  }
  catalog["1217429391-47988-40"] = scene
  catalog["887062449-48025-40"] = scene
  published["@7985443"] = scene
end

-- Rose Garden / normal_large
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0f8356c46.png", -800, -705, 1},
      {"1a0f83586cf.png", -800, 195, 1},
      {"1a0f8359b81.png", 600, -705, 1},
      {"1a0f835b2ce.png", 600, 195, 1},
    },
  }
  catalog["171090748-30688-33"] = scene
  catalog["2049659322-30725-33"] = scene
  published["@7985444"] = scene
end

-- Rose Garden / two
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0f833f541.png", -800, -737, 1},
      {"1a0f8340ca5.png", -800, 163, 1},
      {"1a0f8342416.png", 800, -737, 1},
      {"1a0f8343b7d.png", 800, 163, 1},
    },
  }
  catalog["422089550-31232-57"] = scene
  catalog["1610631496-31269-57"] = scene
  published["@7985445"] = scene
end

-- Rose Garden / three
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0f83452ff.png", -800, -732, 1},
      {"1a0f8346a6e.png", -800, 168, 1},
      {"1a0f83481d9.png", 900, -732, 1},
      {"1a0f8349942.png", 900, 168, 1},
    },
  }
  catalog["64782262-1156-45"] = scene
  catalog["1456495753-1193-45"] = scene
  published["@7985446"] = scene
end

-- Rose Garden / four_three
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0f834b0ba.png", -800, -713, 1},
      {"1a0f834c82b.png", -800, 187, 1},
      {"1a0f834df9f.png", 600, -713, 1},
      {"1a0f834f70f.png", 600, 187, 1},
    },
  }
  catalog["1954301682-62190-45"] = scene
  catalog["1494623454-62227-45"] = scene
  published["@7985447"] = scene
end

-- Rose Garden / normal_xl
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0f8350e86.png", -800, -772, 1},
      {"1a0f8352600.png", -800, 128, 1},
      {"1a0f8353d63.png", 900, -772, 1},
      {"1a0f83554da.png", 900, 128, 1},
    },
  }
  catalog["1010591868-32076-33"] = scene
  catalog["711822481-32113-33"] = scene
end

-- Orbital Station / normal_small
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0f837f860.png", -800, -671, 1},
      {"1a0f83812fe.png", 400, -671, 1},
    },
  }
  catalog["1154021664-41050-38"] = scene
  catalog["209440766-41087-38"] = scene
  published["@7985448"] = scene
end

-- Orbital Station / normal_large
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0f837c99a.png", -800, -673, 1},
      {"1a0f837e0f2.png", 600, -673, 1},
    },
  }
  catalog["1518405818-27700-33"] = scene
  catalog["1059072731-27737-33"] = scene
  published["@7985449"] = scene
end

-- Orbital Station / two
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0f836c7a0.png", -800, -631, 1},
      {"1a0f836df0d.png", 800, -631, 1},
    },
  }
  catalog["979178964-30070-57"] = scene
  catalog["1892853333-30107-57"] = scene
  published["@7985450"] = scene
end

-- Orbital Station / three
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0f836f678.png", -800, -651, 1},
      {"1a0f8370de5.png", -800, 249, 1},
      {"1a0f837255c.png", 900, -651, 1},
      {"1a0f8373cca.png", 900, 249, 1},
    },
  }
  catalog["1701076885-62009-45"] = scene
  catalog["834340717-62046-45"] = scene
  published["@7985451"] = scene
end

-- Orbital Station / four_three
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0f837544c.png", -800, -645, 1},
      {"1a0f8376bbc.png", 600, -645, 1},
    },
  }
  catalog["1412787987-61468-45"] = scene
  catalog["2079887264-61505-45"] = scene
  published["@7985452"] = scene
end

-- Orbital Station / normal_xl
do
  local scene = {
    width=1800, height=400,
    pieces={
      {"1a0f837832f.png", -800, -696, 1},
      {"1a0f8379a93.png", 900, -696, 1},
      {"1a0f837b203.png", 900, 204, 1},
    },
  }
  catalog["490462914-28147-33"] = scene
  catalog["1960013262-28184-33"] = scene
end

-- Bounce Diamonds / normal_small
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0f838d063.png", -1380, -1000, 1},
      {"1a0cfe2275d.png", -1380, 200, 1},
      {"1a0da60f02a.png", 400, -1000, 1},
      {"1a0da61079f.png", 400, 200, 1},
    },
  }
  catalog["1327270132-65364-24"] = scene
  published["@7984900"] = scene
end

-- Water Barrier / two
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9c20ff9.png", -1380, -1000, 1},
      {"1a0f8395d13.png", -1380, 200, 1},
      {"1a0d9c8719f.png", -290, 200, 1},
      {"1a0d9c18354.png", 800, -1000, 1},
      {"1a0d9c19ab7.png", 800, 200, 1},
      {"1a0d9c9e8b3.png", 1890, 200, 1},
    },
  }
  catalog["966444991-49547-44"] = scene
  published["@7985231"] = scene
end

-- Spin Trampolines / normal_small
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da5fbf65.png", -1380, -1000, 1},
      {"1a0da5f9082.png", -1380, 200, 1},
      {"1a0da5f790c.png", 400, -1000, 1},
      {"1a0f838e7e0.png", 400, 200, 1},
    },
  }
  catalog["1545905817-821-24"] = scene
  published["@7984877"] = scene
end

-- Black Pond / two
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0da0b3694.png", -1380, -1000, 1},
      {"1a0da09ee52.png", -1380, 200, 1},
      {"1a0f838ff52.png", 800, -1000, 1},
      {"1a0da0ac14d.png", 800, 200, 1},
    },
  }
  catalog["832829552-31457-36"] = scene
  published["@7984910"] = scene
end

-- Honeymoon / two
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0f83916c5.png", -1380, -1000, 1},
      {"1a0d9d597e0.png", -1380, 200, 1},
      {"1a0d9d5c6c1.png", 800, -1000, 1},
      {"1a0d9d568fd.png", 800, 200, 1},
    },
  }
  catalog["261857337-60945-47"] = scene
  published["@7984906"] = scene
end

-- Light Dark / two
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9d0ba13.png", -1380, -1000, 1},
      {"1a0d9d18d5b.png", -1380, 200, 1},
      {"1a0d9d2f000.png", 800, -1000, 1},
      {"1a0f8392e35.png", 800, 200, 1},
    },
  }
  catalog["994962547-31312-57"] = scene
  published["@7984948"] = scene
  catalog["486093842-31252-57"] = scene
  published["@7985733"] = scene
end

-- Quad Cannons / two
do
  local scene = {
    width=1600, height=400,
    pieces={
      {"1a0d9cb7983.png", -1380, -1000, 1},
      {"1a0d9d05c4d.png", -1380, 200, 1},
      {"1a0d9cfcfa2.png", -290, 200, 1},
      {"1a0d9ceb4b8.png", 800, -1000, 1},
      {"1a0f83945a1.png", 800, 200, 1},
      {"1a0d9cf415f.png", 1890, 200, 1},
    },
  }
  catalog["686773498-50234-45"] = scene
  published["@7985007"] = scene
end

-- No Jump Tower / normal_small
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0f839edd7.png", -1380, -1000, 1},
      {"1a0da4e7349.png", -1380, 200, 1},
      {"1a0da4fd405.png", 400, -1000, 1},
      {"1a0da4ee895.png", 400, 200, 1},
    },
  }
  catalog["1033935322-46612-41"] = scene
  published["@7984995"] = scene
end

-- Portal Soccer / normal_small
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da4f1757.png", -1380, -1000, 1},
      {"1a0da4f463e.png", -1380, 200, 1},
      {"1a0f83a0213.png", 400, -1000, 1},
      {"1a0f83a198c.png", 400, 200, 1},
    },
  }
  catalog["1549043415-38799-62"] = scene
  published["@7985017"] = scene
end

-- Cannon Soccer / normal_small
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da57b347.png", -1380, -1000, 1},
      {"1a0f839bae1.png", -1380, 200, 1},
      {"1a0da569932.png", 400, -1000, 1},
      {"1a0da5725dc.png", 400, 200, 1},
    },
  }
  catalog["525795544-27176-58"] = scene
  published["@7985019"] = scene
end

-- Eeerie Basement / normal_small
do
  local scene = {
    width=800, height=400,
    pieces={
      {"1a0da559750.png", -1380, -1000, 1},
      {"1a0da5623ff.png", -1380, 200, 1},
      {"1a0f839d251.png", 400, -1000, 1},
      {"1a0da550aa8.png", 400, 200, 1},
    },
  }
  catalog["859503558-49629-64"] = scene
  published["@7985021"] = scene
end

-- Cherry Blossom / four_three
do
  local scene = {
    width=1200, height=400,
    pieces={
      {"1a0da6335f7.png", -1380, -1000, 1},
      {"1a0da637c42.png", -1380, 200, 1},
      {"1a0da631e7a.png", 600, -1000, 1},
      {"1a0da6364cf.png", 600, 200, 1},
      {"1a0f839747c.png", 366.76336375488916, 248.9928292046936, 0.06714471968709257},
      {"1a0f839747c.png", 766.7633637548892, 248.9928292046936, 0.06714471968709257},
    },
  }
  catalog["947432607-7939-27"] = scene
  published["@7985277"] = scene
  catalog["4852054-7879-27"] = scene
  published["@7985692"] = scene
end

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

local function drawCourtBorders(xml, width, height, searchMargin)
  if bordersDrawn then return end
  searchMargin = searchMargin or 80
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
        if distance <= searchMargin and distance < distances[side] then
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

-- These hash fields are non-negative integers; encode digits without relying
-- on the host's floating-point string formatting.
local function integerKey(value)
  local result = ''
  repeat
    result = string.char(48 + value % 10) .. result
    value = math.floor(value / 10)
  until value == 0
  return result
end

-- Keep only the last exact XML; published codes still bypass this fallback.
local lastGeometryXML, lastGeometryKey
local function geometryKey(xml)
  if xml == lastGeometryXML then return lastGeometryKey end
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
  local key = integerKey(hash) .. '-' .. integerKey(check) .. '-' .. integerKey(count)
  lastGeometryXML, lastGeometryKey = xml, key
  return key
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
  floorVisuals.setXML(info.xml, info.mapCode, gameState.map.sourceTarget or tfm.get.room.currentMap)
  for name in pairs(hidden) do floorVisuals.show(name) end
  local params = info.xml:match('<P%s+[^>]*>') or ''
  local width = tonumber(mapXml.attribute(params, 'L')) or 800
  local height = tonumber(mapXml.attribute(params, 'H')) or 400
  local code = tostring(gameState.map.sourceTarget or tfm.get.room.currentMap)
  if code:sub(1, 1) ~= '@' then code = '@' .. code end
  local entry = published[code] or catalog[geometryKey(info.xml)]
  -- Scene metadata follows every geometry and published-code alias.
  local noBorders = entry and entry.hideBorders
  -- Honeymoon's four-team background is not uploaded yet.
  noBorders = noBorders or code == '@7984904' or code == '@7984905'
    or code == '@7984906' or code == '@7984907'
  -- Match live catalog targets so exclusions follow map reuploads and mode variants.
  if not noBorders then
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
              break
            end
          end
        end
        if noBorders then break end
      end
      if noBorders then break end
    end
  end
  if not noBorders then drawCourtBorders(info.xml, width, height, entry and entry.borderSearchMargin) end
  if globalSettings.minimalist then status = "minimalist enabled"; return false end
  if not entry then status = "no complete background for this map"; return false end
  if width ~= entry.width or height ~= entry.height then
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
