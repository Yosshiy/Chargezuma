using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gimmick_Stage : MonoBehaviour
{
    [SerializeField] GameObject Poon;
    [SerializeField] ParticleSystem Particle;

    private void Start()
    {
        Poon.transform.DORotate(new Vector3(Poon.transform.rotation.eulerAngles.x,360,0), 5, RotateMode.FastBeyond360)
                      .SetLoops(-1,LoopType.Incremental)
                      .SetEase(Ease.Linear);
    }

    private void OnTriggerEnter(Collider other)
    {
        Poon.GetComponent<Renderer>().material.DOFloat(0,"_ClipTime",2);
        Particle.Play();
    }

    private void OnTriggerExit(Collider other)
    {
        Poon.GetComponent<Renderer>().material.DOFloat(1, "_ClipTime", 2);
    }
}
