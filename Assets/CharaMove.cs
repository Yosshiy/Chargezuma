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
    void Start()
    {
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
        var input = new Vector3(Input.GetAxis("Horizontal") * 15, 0, Input.GetAxis("Vertical") * 15);
        //　移動速度計算
        input.Normalize();
        input *= 10;
        input.y = rb.velocity.y;
        //　移動処理
        rb.velocity = input;
    }

    void Jump()
    {
        var Direction = new Vector3(0, 2, 0);
        rb.AddForce(Direction * 2,ForceMode.Impulse);
        time = Time.time;
    }
    
    void JumpA()
    {
        exittime = Time.time - time;
        if(exittime > 1)
        {
            exittime = 1;
        }
        var Direction = new Vector3(0, exittime, 0);
        rb.AddForce(Direction * 17,ForceMode.Impulse);
    }


}
