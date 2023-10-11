Set  item            "all items"              / dish, ink, lipstick, pen, pencil, perfume /
     subitem1(item)  "first subset of item"   / pen, pencil /
     subitem2(item)  "second subset of item";

subitem2('pen') = uniform(0, 190);
display subitem1, subitem2;