# ✅ Keep everything from Razorpay SDK (safe)
-keep class com.razorpay.** { *; }
-keep interface com.razorpay.** { *; }
-keep class **.zego.** { *; }
-keep class com.itgsa.opensdk.** { *; }
# ✅ Don't warn about any internal annotations Razorpay might use
-dontwarn com.razorpay.**
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers