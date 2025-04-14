# ✅ Keep everything from Razorpay SDK (safe)
-keep class com.razorpay.** { *; }
-keep interface com.razorpay.** { *; }

# ✅ Don't warn about any internal annotations Razorpay might use
-dontwarn com.razorpay.**
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers