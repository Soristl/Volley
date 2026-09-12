local balls = {
  [1] = { id = 6, isImage = false, image = '1a087159d63.png', name = 'Default ball', size = 40, skinScale = 1, previewImage = '1a063033815.png', previewSize = 40 },
  [2] = { id = 608, isImage = false, image = '1a08715b4d5.png', name = 'Futuristic ball', size = 40, skinScale = 1, previewImage = '1a063037e69.png', previewSize = 40 },
  [3] = { id = 611, isImage = false, image = '1a08715cc46.png', name = 'Dino egg ball', size = 40, skinScale = 1, previewImage = '1a063034f85.png', previewSize = 40 },
  [4] = { id = 612, isImage = false, image = '1a08715e3b7.png', name = 'Basketball', size = 40, skinScale = 1, previewImage = '1a06302f1c3.png', previewSize = 40 },
  [5] = { id = 616, isImage = false, image = '1a08715fb2a.png', name = 'Earth ball', size = 40, skinScale = 1, previewImage = '1a0630366f8.png', previewSize = 40 },
  [6] = { id = 619, isImage = false, image = '1a08716129c.png', name = 'Poisoned apple ball', size = 40, skinScale = 1, previewImage = '1a06303ad4e.png', previewSize = 40 },
  [7] = { id = 621, isImage = false, image = '1a087162a0e.png', name = 'Snow globe ball', size = 40, skinScale = 1, previewImage = '1a06303c4c1.png', previewSize = 40 },
  [8] = { id = 626, isImage = false, image = '1a08716417e.png', name = 'Bubble ball', size = 40, skinScale = 1, previewImage = '1a063030932.png', previewSize = 40 },
  [9] = { id = 630, isImage = false, image = '1a08716590c.png', name = 'Moon ball', size = 40, skinScale = 1, previewImage = '1a0630395db.png', previewSize = 40 },
  [10] = { id = 635, isImage = false, image = '1a087167061.png', name = 'Crystal ball', size = 40, skinScale = 1, previewImage = '1a0630320a2.png', previewSize = 40 },
  [11] = { id = 6, isImage = true, image = '1a0871687d2.png', name = 'White Volley ball', category = 'collection', size = 40, skinScale = 1, previewImage = '18fd18e2334.png', previewSize = 30 },
  [12] = { id = 6, isImage = true, image = '1a087169f44.png', name = 'Original Volley ball', category = 'collection', categoryOrder = 0, size = 40, skinScale = 1, previewImage = '18fd18e5dc6.png', previewSize = 30 },
  [13] = { id = 604, isImage = true, image = '1a08716b6b6.png', name = 'Morocco ball', category = 'worldcup', size = 40, skinScale = 1, previewImage = 'img@1a080202d73', previewSize = 30 },
  [14] = { id = 604, isImage = false, image = '1a08716ce27.png', name = 'Soccer ball', size = 40, skinScale = 1, previewImage = '1a06303dc32.png', previewSize = 40 },
  [15] = { id = 6, isImage = true, image = '1a08716e59a.png', name = 'Uruguay ball', category = 'worldcup', size = 40, skinScale = 1, previewImage = 'img@1a08020e8dd', previewSize = 30 },
  [16] = { id = 6, isImage = true, image = '1a08716fd0d.png', name = 'Lagon Volley ball', category = 'collection', size = 40, skinScale = 1, previewImage = 'img@1a0802163d6', previewSize = 30 },
  [17] = { id = 6, isImage = true, image = '1a08717147e.png', name = 'Corail Volley ball', category = 'collection', size = 40, skinScale = 1, previewImage = 'img@1a080213157', previewSize = 30 },
  [18] = { id = 6, isImage = true, image = '1a087172bf0.png', name = 'Royal Volley ball', category = 'collection', size = 40, skinScale = 1, previewImage = 'img@1a08021a21f', previewSize = 30 }
  -- [99] = {
  --   id = 6,
  --   isImage = no,
  --   image = '',
  --   name = 'Custom ball'
  -- }
}

-- Attaches the ball skin image to a spawned ball object.
-- Hosted skins are pre-scaled on 40x40 canvases; render at 1x with centered offsets.
-- previewImage/previewSize preserve the existing selector artwork.
function addBallSkin(objId)
  clubhouse.ballSkins.spawn(objId, balls[gameStats.customBallId])
end
