/obj/random/dbd
    name = "Random DbD item"
    desc = "This is a random piece of loot."

/obj/random/dbd/item_to_spawn()
		return pick(\
						prob(10);/obj/item/device/flashlight/seclite,\
						prob(10);/obj/item/device/flashlight/lantern,\
						prob(2);/obj/item/clothing/glasses/night,\
						prob(2);/obj/item/weapon/gun/projectile/automatic/pistol/colt1911,\
						prob(5);/obj/item/ammo_box/magazine/colt/rubber,\
						prob(5);/obj/item/device/camera_bug,\
						prob(10);/obj/item/device/radio,\
                        prob(2);/obj/item/device/chameleon,\
                        prob(5);/obj/item/weapon/storage/firstaid/tactical\
					)
