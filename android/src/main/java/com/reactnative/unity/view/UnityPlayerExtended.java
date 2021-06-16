package com.reactnative.unity.view;

import android.content.Context;
import android.view.SurfaceView;
import android.view.View;

import com.unity3d.player.IUnityPlayerLifecycleEvents;
import com.unity3d.player.UnityPlayer;

public class UnityPlayerExtended extends UnityPlayer {

    public UnityPlayerExtended(Context context, IUnityPlayerLifecycleEvents eventListener) {
        super(context, eventListener);
    }

    public UnityPlayerExtended(Context context) {
        super(context);
    }

    /**
     * In Unity 2020.3.4 some kind of "m_PersistentUnitySurface" was added to UnityPlayer
     * This has some kind of bug where it tries to add a view that already has a parent
     * which throws and exception and leads to a black screen when entering the game for the second time
     *
     * We try to hack around this by instantly remove views that aren't
     * SurfaceViews when they are added as childs to the UnityPlayer.
     * This probably breaks the splash screen for Unity, but since we aren't showing that it should be ok..
     *
     * This hack should be removed if Unity fixes this..
     * I wrote about in a comment in this https://forum.unity.com/threads/android-crash-on-unity-2019-4-26f.1116979/
     * thread on the Unity forums where others have reported similar issues.
     */
    public void onViewAdded(View view) {
        super.onViewAdded(view);
        if(view.getClass() != SurfaceView.class) {
            this.removeView(view);
        }
    }
}
