using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class PlayerMove : MonoBehaviour
{
    Rigidbody Rigid;
    Vector3 a;
    [SerializeField] GameObject player;

    private void Awake()
    {
        Rigid = GetComponent<Rigidbody>();

        Observable.EveryUpdate()
                  .Where(x => Input.GetKeyDown(KeyCode.V))
                  .Subscribe(x =>
                  {
                      a = transform.position;
                      player.SetActive(true);
                  });
    }

    public void Move(Vector3 pos)
    {
        Rigid.velocity = pos;
    }

    void Update()
    {
        var aa = transform.position - a;
        player.transform.position = a - aa;
    }
}
