using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UniRx;
using UnityEngine;

public class CharaMove : MonoBehaviour
{
    Rigidbody rb;
    float JumpPower;
    float time;
    float exittime;
    float DefaultSpeed = 15;
    float KahenSpeed = 0;
    Tween a;

    void Start()
    {   a = DOTween.To(() => KahenSpeed, (x) => KahenSpeed = x, 0, 1)
               .SetEase(Ease.Linear);
        rb = GetComponent<Rigidbody>();
        Observable.EveryUpdate()
                  .Where(x => Input.GetAxis("Horizontal") != 0)
                  .Subscribe(x => OnMove());

        Observable.EveryUpdate()
                  .Where(x => Input.GetAxis("Vertical") != 0)
                  .Subscribe(x => OnMove());
        Observable.EveryUpdate()
                  .Where(x => Input.GetKeyDown(KeyCode.Space))
                  .Subscribe(x => Jump());

        Observable.EveryUpdate()
                  .Where(x => Input.GetKeyUp(KeyCode.Space))
                  .Subscribe(x => JumpA());
    }

    private void OnMove()
    {
        var input = new Vector3(Input.GetAxis("Horizontal") * DefaultSpeed, 0, Input.GetAxis("Vertical") * DefaultSpeed);
        //　移動速度計算
        input.Normalize();
        input *= 6 + KahenSpeed;
        input.y = rb.velocity.y;
        //　移動処理
        rb.velocity = input;
    }

    void Jump()
    {
        var Direction = new Vector3(0, 4, 0);
        rb.AddForce(Direction * 2,ForceMode.Impulse);
        time = Time.time;
    }

    public void kahen()
    {
        a.Kill();
        KahenSpeed += 5;
        a = DOTween.To(() => KahenSpeed, (x) => KahenSpeed = x, 0, 3)
               .SetEase(Ease.Linear);
    }
    
    void JumpA()
    {
        /*
        exittime = Time.time - time;
        if(exittime > 1)
        {
            exittime = 1;
        }
        var Direction = new Vector3(0, exittime, 0);
        rb.AddForce(Direction * 15,ForceMode.Impulse);
        */
    }


}
