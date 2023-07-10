using System.Collections;
using System.Collections.Generic;
using UniRx;
using UnityEngine;

public class CharaMove : MonoBehaviour
{
    Rigidbody rb;
    float JumpPower;
    
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
        var Direction = new Vector3(Input.GetAxis("Horizontal"),0, Input.GetAxis("Vertical"));
        rb.AddForce(Direction * 7);
    }

    void Jump()
    {
        var Direction = new Vector3(0, 2, 0);
        rb.AddForce(Direction * 2,ForceMode.Impulse);
    }
    
    void JumpA()
    {
        var Direction = new Vector3(0, 5, 0);
        rb.AddForce(Direction * 2,ForceMode.Impulse);
    }


}
