using DG.Tweening;
using UniRx;
using UnityEngine;

public class CharaMove : MonoBehaviour
{
    Rigidbody rb;
    float JumpPower;
    float DefaultSpeed = 15;
    float KahenSpeed = 0;
    Tween a;
    Animator animator;

    void Start()
    {   
        a = DOTween.To(() => KahenSpeed, (x) => KahenSpeed = x, 0, 1)
               .SetEase(Ease.Linear);

        rb = GetComponent<Rigidbody>();
        animator = GetComponent<Animator>();

        Observable.EveryUpdate()
                  .Subscribe(x => OnMove());


        Observable.EveryUpdate()
                  .Where(x => Input.GetKeyDown(KeyCode.Space))
                  .Subscribe(x => Jump());

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

        if(Input.GetAxis("Horizontal") != 0 || Input.GetAxis("Vertical") != 0)
        {
            animator.SetBool("OnWalk", true);
        }
        else if (Input.GetAxis("Horizontal") == 0 && Input.GetAxis("Vertical") == 0)
        {
            animator.SetBool("OnWalk", false);
        }

    }


    void Jump() 
    { 
        animator.SetBool("OnJump",true);
        DOTween.Sequence()
               .AppendInterval(1f)
               .AppendCallback(() =>
               {
                   animator.SetBool("OnJump", false);
               });

        var Direction = new Vector3(0, 4, 0);
        rb.AddForce(Direction * 2,ForceMode.Impulse);
    }

    public void kahen()
    {
        a.Kill();
        KahenSpeed += 5;
        a = DOTween.To(() => KahenSpeed, (x) => KahenSpeed = x, 0, 3)
               .SetEase(Ease.Linear);
        DOTween.Sequence()
               .Append(Camera.main.DOFieldOfView(70,1f))
               .Append(Camera.main.DOFieldOfView(60, 3f));       
    }
    
    public void JumpA()
    {
        animator.SetBool("OnJump", true);

        DOTween.Sequence()
               .AppendInterval(1f)
               .AppendCallback(() =>
               {
                   animator.SetBool("OnJump", false);
               });

        a.Kill();
        KahenSpeed += 5;
        a = DOTween.To(() => KahenSpeed, (x) => KahenSpeed = x, 0, 3)
               .SetEase(Ease.Linear);
    }


}
