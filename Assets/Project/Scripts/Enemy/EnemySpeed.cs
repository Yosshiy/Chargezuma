using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySpeed : EnemyCore
{
    protected override void OnTriggerEnter(Collider other)
    {
        other.gameObject.GetComponent<PlayerCollider>().OnAcceleration();
    }

    protected override void PlayAction()
    {
    }

}
