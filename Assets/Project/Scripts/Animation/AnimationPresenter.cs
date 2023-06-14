using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationPresenter : MonoBehaviour
{
    [SerializeField] AAnimation Parent;

    public void Play()
    {
        Parent.PlayAnimation();
    }

}
