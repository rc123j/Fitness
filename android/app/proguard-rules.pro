# Suppression rules for R8 / Proguard
# The Giphy SDK references kotlinx.parcelize.Parcelize which is not present in the runtime classpath
-dontwarn kotlinx.parcelize.**
