using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerCollider : PlayerCore 
{
    protected override void OnInitialize()
    {
        
    }

    public void OnAcceleration()
    {
        DOTween.Sequence()
               .Append(Camera.main.DOFieldOfView(70, 1f))
               .Append(Camera.main.DOFieldOfView(60, 3f));
        PlayerData.OnAccelerationSpeed += 0.75f;
        PlayerData.AccelerationChanged();
    }

    public void OnJump()
    {
        GetComponent<PlayerMove>().Jump(PlayerData.OnJumpPower * 1.3f);
        PlayerData.OnAccelerationSpeed += 0.5f;
        PlayerData.AccelerationChanged();
    }

    public void OnDeath()
    {

    }
}
