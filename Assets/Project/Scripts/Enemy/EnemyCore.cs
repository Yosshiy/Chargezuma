using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class EnemyCore : MonoBehaviour
{
    protected virtual void OnTriggerEnter(Collider other)
    {
        PlayAction();
    }

    protected virtual void OnCollisionEnter(Collision collision)
    {
        PlayAction();
    }

    protected abstract void PlayAction();
    
}
