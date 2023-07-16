using System.Collections;
using System.Collections.Generic;
using UniRx;
using UnityEngine;

public class PlayerAnimator : PlayerCore
{
    Animator PAnimator;

    protected override void OnInitialize()
    {
        PAnimator = GetComponent<Animator>();

        PlayerInput.OnMoveDirection
                   .Select(x => x != Vector3.zero)
                   .Subscribe(x => Walk = x);

        PlayerInput.OnJump
                   .DistinctUntilChanged()
                   .Subscribe(x => Jump = x);
    }

    public bool Jump { set { PAnimator.SetBool("OnJump", value); } }
    public bool Walk { set { PAnimator.SetBool("OnWalk", value); } }
}
