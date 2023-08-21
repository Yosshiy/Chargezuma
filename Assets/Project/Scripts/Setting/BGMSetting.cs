using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BGMSetting : MonoBehaviour
{
    [SerializeField] AudioSource BGMSource;
    [SerializeField] AudioSource SESource;

    public void Mute(bool value)
    {
        BGMSource.mute = value;
        SESource.mute = value;
    }

    public void BGMVoulume(float volume)
    {
        BGMSource.volume = volume;
    }

    public void SEVolume(float volume)
    {
        SESource.volume = volume;
    }

    public void SetBGM(AudioClip bgm)
    {
        BGMSource.clip = bgm;
    }

    public void SetSE(AudioClip se)
    {
        SESource.clip = se;
    }

    public void SEOneShot(AudioClip se)
    {
        SESource.PlayOneShot(se);
    }
}
