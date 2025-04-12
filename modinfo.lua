name = "Arcueid_dev"
description = "Arc迷迷糊糊遇险中...(开发版)"
author = "cztBlue"
version = "0.5"
forumthread = ""

api_version = 6

dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = false
shipwrecked_compatible = true
hamlet_compatible = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options = {
    {
        name = "amuletstype",
        label = "护符装备类型",
        options = {
            { description = "背包栏", data = 1 },
            { description = "饰品栏", data = 2 },
        },
        default = 2
    }
}

