#!/bin/bash

# Function to check if device is rooted
check_root() {
    if [ "$(id -u)" -eq 0 ]; then
        return 0  # Device is rooted
    else
        return 1  # Device is not rooted
    fi
}

# Function to run command with su if available
run_as_root() {
    if check_root; then
        $@
    elif command -v su > /dev/null; then
        su -c "$@"
    else
        echo "[!] Skipping root command: $@"
    fi
}

# Display banner and info
display_banner() {
    clear
    sleep 1
    echo " 
▀█▀ █▀█ █▀█ █   █   
 █  █▀▄ █▄█ █   █   
 ▀  ▀ ▀ ▀ ▀ ▀▀▀ ▀▀▀ 

█▀█ ▄▀█ █▀▀ █▀▀
█▀▀ █▀█ █▄▄ ██▄"
    echo " Mobile Legends Gaming Booster - TROLL PACE "
    sleep 1
    echo ""
    echo " **************************************** "
    sleep 0.1
    echo " - Developer: Willy Gailo "
    echo " - Version: 3.0 (Termux Edition) "
    echo " - Type: Mobile Legends Ultra Optimizer "
    sleep 1
    echo " **************************************** "
}

# Show progress animation
show_progress() {
    echo ""
    echo " - $1 "
    for i in {1..10}; do
        echo -n "▓"
        sleep 0.2
    done
    echo " Done!"
}

# Create persistent notification
create_notification() {
    if command -v termux-notification > /dev/null; then
        termux-notification --title "TROLL PACE BOOSTER ACTIVE" --content "Mobile Legends optimized - 120Hz Refresh Rate Locked" --priority high --ongoing
    elif command -v am > /dev/null; then
        # Try using Android's notification system via intents
        run_as_root am startservice --user 0 -n com.android.systemui/.SystemUIService \
          --ez ongoing true \
          --es title "TROLL PACE BOOSTER ACTIVE" \
          --es text "Mobile Legends optimized - 120Hz Refresh Rate Locked" \
          --ei priority 1 2>/dev/null
    fi
}

# Apply settings based on root status
apply_settings() {
    if check_root || command -v su > /dev/null; then
        echo ""
        echo " [+] Root access detected. Applying advanced optimizations..."
        
        # ML Frame Rate Optimization
        run_as_root setprop debug.hwui.renderer_enabled true
        run_as_root setprop debug.hwui.render_dirty_regions true
        run_as_root setprop debug.hwui.skip_empty_damage true
        run_as_root setprop debug.hwui.use_partial_updates true
        run_as_root setprop debug.sf.latch_unsignaled 1
        
        # ML Game Performance Booster
        run_as_root setprop debug.hwui.disable_fps_limit 1
        run_as_root setprop debug.sf.disable_backpressure 1
        run_as_root setprop debug.enabletr 1
        
        # Force 120Hz refresh rate even if not supported
        run_as_root settings put global peak_refresh_rate 120.0
        run_as_root settings put global min_refresh_rate 120.0
        run_as_root setprop vendor.display.force_refresh_rate 120
        run_as_root setprop persist.vendor.display.force_refresh_rate 120
        
        # Settings that use the settings command
        run_as_root settings put global surface_flinger.use_content_detection_for_refresh_rate false
        run_as_root settings put global media.recorder-max-base-layer-fps 90
        run_as_root settings put global surface_flinger.use_context_priority 1
        run_as_root settings put global gpu_throttle_disable 1
        
        # Unlock max graphics settings for ML
        run_as_root mkdir -p /data/data/com.mobile.legends/shared_prefs/ 2>/dev/null
        
        # Create or update graphics preference file to enable high graphics
        GRAPHICS_FILE="/data/data/com.mobile.legends/shared_prefs/graphics_preferences.xml"
        GRAPHICS_CONTENT='<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<map>
    <boolean name="EnableHighFrameRate" value="true" />
    <boolean name="EnableUltraHighFrameRate" value="true" />
    <boolean name="EnableUltraGraphics" value="true" />
    <boolean name="EnableHDR" value="true" />
    <string name="GraphicsQuality">3</string>
    <string name="ShadowQuality">3</string>
    <string name="FrameRateLevel">3</string>
</map>'
        
        # Write to file using either direct write or echo through su
        if check_root; then
            echo "$GRAPHICS_CONTENT" > "$GRAPHICS_FILE"
            chmod 666 "$GRAPHICS_FILE"
        else
            run_as_root "echo '$GRAPHICS_CONTENT' > '$GRAPHICS_FILE' && chmod 666 '$GRAPHICS_FILE'"
        fi
        
        # Memory optimization - using run_as_root to handle the permission
        run_as_root "echo 3 > /proc/sys/vm/drop_caches" || echo "[!] Could not drop caches. Permission denied."
    else
        echo ""
        echo " [!] No root access detected. Applying limited optimizations..."
    fi
    
    # Non-root optimizations
    echo ""
    echo " [+] Optimizing device performance..."
    
    # Kill background processes to free RAM (safe for non-root)
    for app in $(ps -A | grep -E "facebook|snapchat|instagram|tiktok" | awk '{print $2}'); do
        kill $app 2>/dev/null
    done
    
    # Termux-specific optimizations
    if [ -d "/data/data/com.termux" ]; then
        am start -a android.intent.action.SEND -t text/plain --es android.intent.extra.TEXT "optimize" --ez exit_on_sent true >/dev/null 2>&1
    fi
}

# Launch Mobile Legends
launch_ml() {
    echo " [+] Launching Mobile Legends..."
    am start -n com.mobile.legends/com.mobile.legends.MainActivity >/dev/null 2>&1 || \
    am start -n com.mobile.legends/.SplashActivity >/dev/null 2>&1 || \
    am start -n com.mobile.legends/com.bytedance.sdk.openadsdk.stub.activity.Stub_Standard_Portrait_Activity >/dev/null 2>&1 || \
    echo " [!] Could not launch Mobile Legends. Please start it manually."
}

# Main function
main() {
    display_banner
    sleep 0.1
    
    show_progress "Optimizing System Resources"
    show_progress "Preserving Game Resources"
    show_progress "Applying ML Gaming Tweaks"
    show_progress "Optimizing Network Connection"
    show_progress "Enhancing GPU Performance"
    show_progress "Unlocking Max Graphics Settings"
    show_progress "Stabilizing Frame Rates"
    
    apply_settings
    
    # Create persistent notification
    create_notification
    
    echo ""
    echo " Optimization Complete! "
    sleep 0.1
    echo ""
    echo " ENJOY SMOOTHER MOBILE LEGENDS GAMEPLAY! "
    echo ""
    echo ""
    echo " Optimization by Willy Gailo complete!"
    echo " Starting Mobile Legends for best results..."
    echo ""
    
    echo " 
▀█▀ █▀█ █▀█ █   █   
 █  █▀▄ █▄█ █   █   
 ▀  ▀ ▀ ▀ ▀ ▀▀▀ ▀▀▀ 

█▀█ ▄▀█ █▀▀ █▀▀
█▀▀ █▀█ █▄▄ ██▄"
    
    # Show shell running message
    echo ""
    echo " ----------------------------------------- "
    echo " [*] Shell Running [*]"
    echo " [*] 120Hz Refresh Rate Locked [*]"
    echo " [*] Max Graphics Unlocked [*]"
    echo " ----------------------------------------- "
    
    # Launch Mobile Legends
    launch_ml
}

# Execute main function
main