--- epan/print.c.orig	2021-11-13 23:00:00 UTC
+++ epan/print.c
@@ -1216,15 +1216,8 @@ ek_write_name(proto_node *pnode, gchar* suffix, write_
 {
     field_info *fi = PNODE_FINFO(pnode);
     gchar      *str;
-
-    if (fi->hfinfo->parent != -1) {
-        header_field_info* parent = proto_registrar_get_nth(fi->hfinfo->parent);
-        str = g_strdup_printf("%s_%s%s", parent->abbrev, fi->hfinfo->abbrev, suffix ? suffix : "");
-        json_dumper_set_member_name(pdata->dumper, str);
-    } else {
-        str = g_strdup_printf("%s%s", fi->hfinfo->abbrev, suffix ? suffix : "");
-        json_dumper_set_member_name(pdata->dumper, str);
-    }
+    str = g_strdup_printf("%s%s", fi->hfinfo->abbrev, suffix ? suffix : "");
+    json_dumper_set_member_name(pdata->dumper, str);
     g_free(str);
 }
 
